<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

adminEskatu(); // administratzaileak soilik (saioa eta rola egiaztatzen ditu)
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Metodoa ez da onartzen.']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true) ?? [];
$izena = trim((string) ($input['izena'] ?? ''));
$taldea = trim((string) ($input['taldea'] ?? ''));

// Zerbitzariaren aldeko baliozkotzea (bezeroarena ez da nahikoa)
$erroreak = [];
if ($izena === '' || mb_strlen($izena) > 100) {
    $erroreak[] = 'Izena derrigorrezkoa da (gehienez 100 karaktere).';
}
if (mb_strlen($taldea) > 100) {
    $erroreak[] = 'Taldea luzeegia da (gehienez 100 karaktere).';
}
if ($erroreak) {
    jsonErantzun(422, ['success' => false, 'message' => implode(' ', $erroreak)]);
}

try {
    $pdo = (new DB())->getKonexioa();

    // Izena bakarra izan dadin (taularen collation-a: maiuskulak/minuskulak berdin)
    $stmt = $pdo->prepare('SELECT 1 FROM gelak WHERE izena = :izena');
    $stmt->execute(['izena' => $izena]);
    if ($stmt->fetchColumn()) {
        jsonErantzun(409, ['success' => false, 'message' => 'Izen hori duen gela badago jada.']);
    }

    $stmt = $pdo->prepare('INSERT INTO gelak (izena, taldea) VALUES (:izena, :taldea)');
    $stmt->execute(['izena' => $izena, 'taldea' => $taldea === '' ? null : $taldea]);

    echo json_encode([
        'success' => true,
        'gela' => ['id' => (int) $pdo->lastInsertId(), 'izena' => $izena, 'taldea' => $taldea],
    ]);
} catch (Throwable $e) {
    error_log($e->getMessage());
    jsonErantzun(500, ['success' => false, 'message' => 'Errorea gela sortzean.']);
}
