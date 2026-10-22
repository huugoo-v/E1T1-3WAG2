<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'saioa' => false, 'message' => 'Saioa hasi behar duzu.']);
    exit;
}
try {
    $stmt = (new DB())->getKonexioa()->query('SELECT username, rol FROM erabiltzaileak ORDER BY username');
    echo json_encode(['success' => true, 'erabiltzaileak' => $stmt->fetchAll()]);
} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errorea erabiltzaileak kargatzean.']);
}
