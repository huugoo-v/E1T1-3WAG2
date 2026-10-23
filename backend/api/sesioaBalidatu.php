<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

saioaEskatu();

echo json_encode([
    'success' => true,
    'username' => $_SESSION['username'] ?? null,
    'rol' => $_SESSION['rol'] ?? 'user'
]);
