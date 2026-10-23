<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

saioaEskatu();
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Metodoa ez da onartzen.']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true) ?? [];
$id = filter_var($input['id'] ?? null, FILTER_VALIDATE_INT);
if (!$id || $id < 1) {
    jsonErantzun(422, ['success' => false, 'message' => 'ID baliogabea.']);
}
try {
    $stmt = (new DB())->getKonexioa()->prepare('DELETE FROM baliabideak WHERE id = :id');
    $stmt->execute(['id' => $id]);
    echo json_encode(['success' => $stmt->rowCount() > 0, 'message' => $stmt->rowCount() ? '' : 'Baliabidea ez da aurkitu.']);
} catch (PDOException $e) {
    if ($e->getCode() === '23000') {
        jsonErantzun(409, ['success' => false, 'message' => 'Ezin da ezabatu: baliabide honek gailuak ditu esleituta.']);
    }
    error_log($e->getMessage());
    jsonErantzun(500, ['success' => false, 'message' => 'Errorea baliabidea ezabatzean.']);
} catch (Throwable $e) {
    error_log($e->getMessage());
    jsonErantzun(500, ['success' => false, 'message' => 'Errorea baliabidea ezabatzean.']);
}
