<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

saioaEskatu();
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

// Zerbitzariaren aldeko baliozkotzea (bezeroarena ez da nahikoa)
$erroreak = [];
if ($izena === '' || mb_strlen($izena) > 150) {
    $erroreak[] = 'Izena derrigorrezkoa da (gehienez 150 karaktere).';
}
if (mb_strlen($marka) > 100) {
    $erroreak[] = 'Marka luzeegia da (gehienez 100 karaktere).';
}
if (mb_strlen($modeloa) > 100) {
    $erroreak[] = 'Modeloa luzeegia da (gehienez 100 karaktere).';
}
if (mb_strlen($deskribapena) > 2000) {
    $erroreak[] = 'Deskribapena luzeegia da (gehienez 2000 karaktere).';
}
if (!$kategoriaId || $kategoriaId < 1) {
    $erroreak[] = 'Kategoria zuzena aukeratu behar da.';
}
if ($erroreak) {
    jsonErantzun(422, ['success' => false, 'message' => implode(' ', $erroreak)]);
}

try {
    $pdo = (new DB())->getKonexioa();

    $stmt = $pdo->prepare('SELECT 1 FROM kategoriak WHERE id = :id');
    $stmt->execute(['id' => $kategoriaId]);
    if (!$stmt->fetchColumn()) {
        jsonErantzun(422, ['success' => false, 'message' => 'Kategoria ez da existitzen.']);
    }

    if ($id) {
        $stmt = $pdo->prepare('SELECT 1 FROM baliabideak WHERE id = :id');
        $stmt->execute(['id' => $id]);
        if (!$stmt->fetchColumn()) {
            jsonErantzun(404, ['success' => false, 'message' => 'Baliabidea ez da aurkitu.']);
        }
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
