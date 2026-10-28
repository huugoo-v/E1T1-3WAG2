<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

saioaEskatu();

try {
    // Gelen arteko mugimenduak soilik: gailu baten egonaldi bakoitza aurreko egonaldiarekin parekatzen da
    // (id handiena duen aurrekoa). Lehen esleipena (aurrekorik gabea) ez da mugimendutzat hartzen.
    $sql = 'SELECT m.id, ga.etiketa, b.izena AS materiala, b.marka, b.modeloa,
                   gi.izena AS nondik, gn.izena AS nora,
                   m.hasieraData AS data, e.username AS erabiltzailea
            FROM mugimenduak m
            JOIN mugimenduak p ON p.id = (
                SELECT MAX(x.id) FROM mugimenduak x
                WHERE x.gailuId = m.gailuId AND x.id < m.id
            )
            JOIN gelak gi ON gi.id = p.gelaId
            JOIN gelak gn ON gn.id = m.gelaId
            JOIN gailuak ga ON ga.id = m.gailuId
            JOIN baliabideak b ON b.id = ga.baliabideId
            JOIN erabiltzaileak e ON e.id = m.erabiltzaileId
            WHERE p.gelaId <> m.gelaId
            ORDER BY m.hasieraData DESC, m.id DESC';
    $stmt = (new DB())->getKonexioa()->query($sql);
    echo json_encode(['success' => true, 'mugimenduak' => $stmt->fetchAll()]);
} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errorea mugimenduak kargatzean.']);
}
