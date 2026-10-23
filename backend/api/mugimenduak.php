<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

saioaEskatu();

try {
    $sql = 'SELECT m.id, g.izena AS gela, ga.etiketa, b.izena AS materiala,
                   e.username AS erabiltzailea, m.hasieraData, m.amaieraData
            FROM mugimenduak m
            JOIN gelak g ON g.id = m.gelaId
            JOIN gailuak ga ON ga.id = m.gailuId
            JOIN baliabideak b ON b.id = ga.baliabideId
            JOIN erabiltzaileak e ON e.id = m.erabiltzaileId
            ORDER BY m.hasieraData DESC, m.id DESC';
    $stmt = (new DB())->getKonexioa()->query($sql);
    echo json_encode(['success' => true, 'mugimenduak' => $stmt->fetchAll()]);
} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errorea mugimenduak kargatzean.']);
}
