<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'saioa' => false, 'message' => 'Saioa hasi behar duzu.']);
    exit;
}

echo json_encode([
    'success' => true,
    'rol' => $_SESSION['rol'] ?? null
]);
