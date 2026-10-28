<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

saioaEskatu();
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Metodoa ez da onartzen.']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true) ?? [];
$gailuId = filter_var($input['gailuId'] ?? null, FILTER_VALIDATE_INT);
$gelaId = filter_var($input['gelaId'] ?? null, FILTER_VALIDATE_INT);
if (!$gailuId || $gailuId < 1 || !$gelaId || $gelaId < 1) {
    jsonErantzun(422, ['success' => false, 'message' => 'Gailua eta helburuko gela aukeratu behar dira.']);
}

$pdo = (new DB())->getKonexioa();

/** Transakzioa bertan behera utzi eta errorea erantzun. */
$utzi = function (int $kodea, string $mezua) use ($pdo): void {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    jsonErantzun($kodea, ['success' => false, 'message' => $mezua]);
};

try {
    $pdo->beginTransaction();

    // Gailua existitzen da?
    $stmt = $pdo->prepare('SELECT ga.etiketa, b.izena AS materiala
                           FROM gailuak ga
                           JOIN baliabideak b ON b.id = ga.baliabideId
                           WHERE ga.id = :id');
    $stmt->execute(['id' => $gailuId]);
    $gailua = $stmt->fetch();
    if (!$gailua) {
        $utzi(404, 'Gailua ez da aurkitu.');
    }

    // Helburuko gela existitzen da?
    $stmt = $pdo->prepare('SELECT izena FROM gelak WHERE id = :id');
    $stmt->execute(['id' => $gelaId]);
    $nora = $stmt->fetchColumn();
    if ($nora === false) {
        $utzi(404, 'Helburuko gela ez da existitzen.');
    }

    // Uneko gela = itxi gabeko mugimendua. FOR UPDATE: bi mugimendu batera egitea saihesten du.
    $stmt = $pdo->prepare('SELECT m.gelaId, g.izena AS gela
                           FROM mugimenduak m
                           JOIN gelak g ON g.id = m.gelaId
                           WHERE m.gailuId = :gailu AND m.amaieraData IS NULL
                           ORDER BY m.id DESC
                           LIMIT 1
                           FOR UPDATE');
    $stmt->execute(['gailu' => $gailuId]);
    $unekoa = $stmt->fetch();
    if (!$unekoa) {
        $utzi(409, 'Gailu hau ez dago gela batean esleituta.');
    }
    if ((int) $unekoa['gelaId'] === $gelaId) {
        $utzi(422, 'Gailua dagoeneko gela horretan dago.');
    }

    // Uneko egonaldia itxi eta berria ireki; bi pausoak elkarrekin gordetzen dira.
    $stmt = $pdo->prepare('UPDATE mugimenduak SET amaieraData = CURDATE()
                           WHERE gailuId = :gailu AND amaieraData IS NULL');
    $stmt->execute(['gailu' => $gailuId]);

    $stmt = $pdo->prepare('INSERT INTO mugimenduak (gelaId, gailuId, erabiltzaileId, hasieraData)
                           VALUES (:gela, :gailu, :erabiltzailea, CURDATE())');
    $stmt->execute([
        'gela' => $gelaId,
        'gailu' => $gailuId,
        'erabiltzailea' => (int) $_SESSION['user_id'],
    ]);

    $pdo->commit();

    echo json_encode([
        'success' => true,
        'mugimendua' => [
            'etiketa' => $gailua['etiketa'],
            'materiala' => $gailua['materiala'],
            'nondik' => $unekoa['gela'],
            'nora' => $nora,
        ],
    ]);
} catch (Throwable $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    error_log($e->getMessage());
    jsonErantzun(500, ['success' => false, 'message' => 'Errorea gailua mugitzean.']);
}
