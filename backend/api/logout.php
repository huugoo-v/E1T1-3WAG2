<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');
saioaHustu();
echo json_encode(['success' => true]);
