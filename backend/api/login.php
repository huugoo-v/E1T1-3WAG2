<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Metodoa ez da onartzen.']);
    exit;
}

const SAIAKERA_MAX = 5;     // saiakera hutsegin kopuru maximoa
const BLOKEO_SEGUNDUAK = 60; // blokeoaren iraupena

if (($_SESSION['blokeoa'] ?? 0) > time()) {
    jsonErantzun(429, ['success' => false, 'message' => 'Saiakera gehiegi. Itxaron minutu bat eta saiatu berriro.']);
}

$erabiltzaile = trim($_POST['erabiltzaile'] ?? '');
$pasahitza = $_POST['pasahitza'] ?? '';
if ($erabiltzaile === '' || $pasahitza === '') {
    jsonErantzun(422, ['success' => false, 'message' => 'Eremuak ezin dira hutsik egon.']);
}
if (mb_strlen($erabiltzaile) > 50 || strlen($pasahitza) > 255) {
    jsonErantzun(422, ['success' => false, 'message' => 'Erabiltzailea edo pasahitza okerrak.']);
}

try {
    $db = new DB();
    $stmt = $db->getKonexioa()->prepare('SELECT id, username, pasahitza, rol FROM erabiltzaileak WHERE username = :username');
    $stmt->execute(['username' => $erabiltzaile]);
    $user = $stmt->fetch();

    // Erabiltzailea existitzen ez bada ere hash bat egiaztatzen da, erantzun-denbora berdina izateko
    $hasha = $user['pasahitza'] ?? '$2y$10$abcdefghijklmnopqrstuuG6Z3yq0xZlYxQ1Jw8o5rZ0yq3Qm1m1e';
    $zuzena = password_verify($pasahitza, $hasha);

    if (!$user || !$zuzena) {
        $_SESSION['saiakerak'] = ($_SESSION['saiakerak'] ?? 0) + 1;
        if ($_SESSION['saiakerak'] >= SAIAKERA_MAX) {
            $_SESSION['blokeoa'] = time() + BLOKEO_SEGUNDUAK;
            $_SESSION['saiakerak'] = 0;
        }
        usleep(400000);
        jsonErantzun(401, ['success' => false, 'message' => 'Erabiltzailea edo pasahitza okerrak.']);
    }

    session_regenerate_id(true);
    $_SESSION = [];
    $_SESSION['user_id'] = $user['id'];
    $_SESSION['username'] = $user['username'];
    $_SESSION['rol'] = $user['rol'] === 'admin' ? 'admin' : 'user';
    $_SESSION['azkenJarduera'] = time();
    echo json_encode(['success' => true]);
} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errorea saioa hastean.']);
}
