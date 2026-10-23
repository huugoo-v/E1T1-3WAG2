<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

saioaEskatu();

try {
    $pdo = (new DB())->getKonexioa();

    // Gelarik ez badago, hasierako sei gelak sortu.
    $kopurua = (int) $pdo->query('SELECT COUNT(*) FROM gelak')->fetchColumn();
    if ($kopurua === 0) {
        $stmt = $pdo->prepare('INSERT INTO gelak (izena, taldea) VALUES (?, ?)');
        foreach ([
            ['Gela 1', 'DAW'],
            ['Gela 2', 'DAW'],
            ['Gela 3', 'Administrazioa'],
            ['Gela 4', 'Sareak'],
            ['Gela 5', 'Irakasleak'],
            ['Mintegia', 'Informatika mintegia'],
            ['Biltegia', 'Biltegia'],
        ] as [$izena, $taldea]) {
            $stmt->execute([$izena, $taldea]);
        }
    }

    $sql = 'SELECT g.id AS gelaId, g.izena AS gela, g.taldea,
                   ga.id AS gailuId, ga.etiketa, ga.egoera,
                   b.izena AS materiala, b.marka, b.modeloa, b.deskribapena,
                   k.izena AS kategoria
            FROM gelak g
            LEFT JOIN mugimenduak m ON m.gelaId = g.id AND m.amaieraData IS NULL
            LEFT JOIN gailuak ga ON ga.id = m.gailuId
            LEFT JOIN baliabideak b ON b.id = ga.baliabideId
            LEFT JOIN kategoriak k ON k.id = b.kategoriaId
            ORDER BY g.id, b.izena';
    $rows = $pdo->query($sql)->fetchAll();

    $gelak = [];
    foreach ($rows as $row) {
        $id = (int) $row['gelaId'];
        if (!isset($gelak[$id])) {
            $gelak[$id] = [
                'id' => $id,
                'izena' => $row['gela'],
                'taldea' => $row['taldea'] ?? '',
                'materialak' => []
            ];
        }
        if ($row['gailuId'] !== null) {
            $gelak[$id]['materialak'][] = [
                'id' => (int) $row['gailuId'],
                'etiketa' => $row['etiketa'],
                'izena' => $row['materiala'],
                'marka' => $row['marka'] ?? '',
                'modeloa' => $row['modeloa'] ?? '',
                'egoera' => $row['egoera'] ?? '',
                'kategoria' => $row['kategoria'] ?? 'Beste batzuk',
                'deskribapena' => $row['deskribapena'] ?? ''
            ];
        }
    }

    echo json_encode(['success' => true, 'gelak' => array_values($gelak)]);
} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errorea gelak eta materialak kargatzean.']);
}
