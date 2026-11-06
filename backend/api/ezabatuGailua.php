<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

adminEskatu(); // administratzaileak soilik: gailuaren mugimendu-historia ere ezabatzen da
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

$pdo = (new DB())->getKonexioa();

try {
    $pdo->beginTransaction();

    $stmt = $pdo->prepare('SELECT baliabideId FROM gailuak WHERE id = :id');
    $stmt->execute(['id' => $id]);
    $baliabideId = $stmt->fetchColumn();
    if ($baliabideId === false) {
        $pdo->rollBack();
        jsonErantzun(404, ['success' => false, 'message' => 'Gailua ez da aurkitu.']);
    }

    // Gailuaren mugimenduak (historia) lehenago, kanpo-gakoak horrela behar baitu
    $stmt = $pdo->prepare('DELETE FROM mugimenduak WHERE gailuId = :id');
    $stmt->execute(['id' => $id]);

    $stmt = $pdo->prepare('DELETE FROM gailuak WHERE id = :id');
    $stmt->execute(['id' => $id]);

    // Mota honetako azken gailua bazen, mota ere ezabatzen da (ez da inon agertzen)
    $stmt = $pdo->prepare('DELETE FROM baliabideak
                           WHERE id = :baliabide AND NOT EXISTS (SELECT 1 FROM gailuak WHERE baliabideId = :baliabide2)');
    $stmt->execute(['baliabide' => $baliabideId, 'baliabide2' => $baliabideId]);

    $pdo->commit();
    echo json_encode(['success' => true]);
} catch (Throwable $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    error_log($e->getMessage());
    jsonErantzun(500, ['success' => false, 'message' => 'Errorea gailua ezabatzean.']);
}
