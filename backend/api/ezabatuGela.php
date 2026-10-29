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
$id = filter_var($input['id'] ?? null, FILTER_VALIDATE_INT);
if (!$id || $id < 1) {
    jsonErantzun(422, ['success' => false, 'message' => 'ID baliogabea.']);
}

try {
    $pdo = (new DB())->getKonexioa();

    $stmt = $pdo->prepare('SELECT izena FROM gelak WHERE id = :id');
    $stmt->execute(['id' => $id]);
    if ($stmt->fetchColumn() === false) {
        jsonErantzun(404, ['success' => false, 'message' => 'Gela ez da aurkitu.']);
    }

    // Gelan gailurik badago, ez da ezabatzen: lehenago beste gela batera mugitu behar dira.
    $stmt = $pdo->prepare('SELECT COUNT(*) FROM mugimenduak WHERE gelaId = :id AND amaieraData IS NULL');
    $stmt->execute(['id' => $id]);
    $kopurua = (int) $stmt->fetchColumn();
    if ($kopurua > 0) {
        jsonErantzun(409, [
            'success' => false,
            'message' => "Ezin da ezabatu: gela honetan $kopurua material dago. Mugitu itzazu beste gela batera lehenago.",
        ]);
    }

    $stmt = $pdo->prepare('DELETE FROM gelak WHERE id = :id');
    $stmt->execute(['id' => $id]);
    echo json_encode(['success' => $stmt->rowCount() > 0, 'message' => $stmt->rowCount() ? '' : 'Gela ez da aurkitu.']);
} catch (PDOException $e) {
    // 23000: gela honek mugimendu-historia du (aurretik materiala izan du). Historia ez da galtzen.
    if ($e->getCode() === '23000') {
        jsonErantzun(409, [
            'success' => false,
            'message' => 'Ezin da ezabatu: gela honek mugimendu-historia dauka (materiala izan du).',
        ]);
    }
    error_log($e->getMessage());
    jsonErantzun(500, ['success' => false, 'message' => 'Errorea gela ezabatzean.']);
} catch (Throwable $e) {
    error_log($e->getMessage());
    jsonErantzun(500, ['success' => false, 'message' => 'Errorea gela ezabatzean.']);
}
