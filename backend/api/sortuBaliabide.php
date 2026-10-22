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

$id = filter_input(INPUT_POST, 'id', FILTER_VALIDATE_INT);
$izena = trim($_POST['izena'] ?? '');
$marka = trim($_POST['marka'] ?? '');
$modeloa = trim($_POST['modeloa'] ?? '');
$kategoriaId = filter_input(INPUT_POST, 'kategoria_id', FILTER_VALIDATE_INT);
$deskribapena = trim($_POST['deskribapena'] ?? '');

if ($izena === '' || !$kategoriaId || $kategoriaId < 1 || $kategoriaId > 4) {
    echo json_encode(['success' => false, 'message' => 'Izena eta kategoria zuzenak sartu behar dituzu.']);
    exit;
}

try {
    $pdo = (new DB())->getKonexioa();
    if ($id) {
        $stmt = $pdo->prepare('UPDATE baliabideak SET izena=:izena, marka=:marka, modeloa=:modeloa, kategoriaId=:kategoriaId, deskribapena=:deskribapena WHERE id=:id');
        $stmt->execute(['izena' => $izena, 'marka' => $marka, 'modeloa' => $modeloa, 'kategoriaId' => $kategoriaId, 'deskribapena' => $deskribapena, 'id' => $id]);
    } else {
        $stmt = $pdo->prepare('INSERT INTO baliabideak (izena, marka, modeloa, kategoriaId, deskribapena) VALUES (:izena, :marka, :modeloa, :kategoriaId, :deskribapena)');
        $stmt->execute(['izena' => $izena, 'marka' => $marka, 'modeloa' => $modeloa, 'kategoriaId' => $kategoriaId, 'deskribapena' => $deskribapena]);
    }
    echo json_encode(['success' => true]);
} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errorea baliabidea gordetzean.']);
}
