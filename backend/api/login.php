<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Metodoa ez da onartzen.']);
    exit;
}

$erabiltzaile = trim($_POST['erabiltzaile'] ?? '');
$pasahitza = $_POST['pasahitza'] ?? '';
if ($erabiltzaile === '' || $pasahitza === '') {
    echo json_encode(['success' => false, 'message' => 'Eremuak ezin dira hutsik egon.']);
    exit;
}

try {
    $db = new DB();
    $stmt = $db->getKonexioa()->prepare('SELECT id, username, pasahitza, rol FROM erabiltzaileak WHERE username = :username');
    $stmt->execute(['username' => $erabiltzaile]);
    $user = $stmt->fetch();

    if (!$user || !password_verify($pasahitza, $user['pasahitza'])) {
        echo json_encode(['success' => false, 'message' => 'Erabiltzailea edo pasahitza okerrak.']);
        exit;
    }

    session_regenerate_id(true);
    $_SESSION['user_id'] = $user['id'];
    $_SESSION['username'] = $user['username'];
    $_SESSION['rol'] = $user['rol'];
    echo json_encode(['success' => true]);
} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errorea saioa hastean.']);
}
