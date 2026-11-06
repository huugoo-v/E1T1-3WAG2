<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

saioaEskatu();

try {
    $pdo = (new DB())->getKonexioa();

    // Alta/edizio inprimakiko gelen zerrenda
    if (isset($_GET['gelak'])) {
        $stmt = $pdo->query('SELECT id, izena, taldea FROM gelak ORDER BY id');
        echo json_encode(['success' => true, 'gelak' => $stmt->fetchAll()]);
        exit;
    }

    // Gailu bakoitza bere uneko gelarekin (itxi gabeko mugimendua)
    $oinarria = 'SELECT ga.id, ga.etiketa, ga.egoera, ga.erosketaData,
                        b.kategoriaId, k.izena AS kategoria, b.izena, b.marka, b.modeloa, b.deskribapena,
                        g.id AS gelaId, g.izena AS gela
                 FROM gailuak ga
                 JOIN baliabideak b ON b.id = ga.baliabideId
                 JOIN kategoriak k ON k.id = b.kategoriaId
                 LEFT JOIN mugimenduak m ON m.gailuId = ga.id AND m.amaieraData IS NULL
                 LEFT JOIN gelak g ON g.id = m.gelaId';

    // Gailu bakarra (edizioa)
    if (isset($_GET['id'])) {
        $stmt = $pdo->prepare($oinarria . ' WHERE ga.id = ?');
        $stmt->execute([(int) $_GET['id']]);
        $gailua = $stmt->fetch();
        echo json_encode([
            'success' => (bool) $gailua,
            'gailua' => $gailua ?: null,
            'message' => $gailua ? '' : 'Gailua ez da aurkitu.',
        ]);
        exit;
    }

    // Zerrenda osoa; bilaketa: hitz bakoitzak zutabe batean gutxienez agertu behar du
    $hitzak = preg_split('/\s+/', trim($_GET['bilatu'] ?? ''), -1, PREG_SPLIT_NO_EMPTY);
    $hitzak = array_slice($hitzak, 0, 6);
    $baldintzak = [];
    $parametroak = [];
    foreach ($hitzak as $hitza) {
        $baldintzak[] = '(ga.etiketa LIKE ? OR b.izena LIKE ? OR b.marka LIKE ? OR b.modeloa LIKE ?
                          OR k.izena LIKE ? OR g.izena LIKE ? OR ga.egoera LIKE ? OR b.deskribapena LIKE ?)';
        array_push($parametroak, ...array_fill(0, 8, '%' . $hitza . '%'));
    }
    $sql = $oinarria . ($baldintzak ? ' WHERE ' . implode(' AND ', $baldintzak) : '') . ' ORDER BY ga.id';
    $stmt = $pdo->prepare($sql);
    $stmt->execute($parametroak);
    echo json_encode(['success' => true, 'gailuak' => $stmt->fetchAll()]);
} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errorea datuak kargatzean.']);
}
