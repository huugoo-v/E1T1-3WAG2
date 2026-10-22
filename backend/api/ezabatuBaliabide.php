<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'saioa' => false, 'message' => 'Saioa hasi behar duzu.']);
    exit;
}
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Metodoa ez da onartzen.']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true) ?? [];
$id = filter_var($input['id'] ?? null, FILTER_VALIDATE_INT);
if (!$id || $id < 1) {
    echo json_encode(['success' => false, 'message' => 'ID baliogabea.']);
    exit;
}
try {
    $stmt = (new DB())->getKonexioa()->prepare('DELETE FROM baliabideak WHERE id = :id');
    $stmt->execute(['id' => $id]);
    echo json_encode(['success' => $stmt->rowCount() > 0, 'message' => $stmt->rowCount() ? '' : 'Baliabidea ez da aurkitu.']);
} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errorea baliabidea ezabatzean.']);
}
