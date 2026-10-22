<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['success' => false, 'saioa' => false, 'message' => 'Saioa hasi behar duzu.']);
    exit;
}

try {
    $pdo = (new DB())->getKonexioa();
    if (isset($_GET['id'])) {
        $stmt = $pdo->prepare('SELECT id, kategoriaId, izena, marka, modeloa, deskribapena FROM baliabideak WHERE id = :id');
        $stmt->execute(['id' => (int) $_GET['id']]);
        $item = $stmt->fetch();
        echo json_encode(['success' => (bool) $item, 'baliabidea' => $item ?: null, 'message' => $item ? '' : 'Baliabidea ez da aurkitu.']);
        exit;
    }

    $bilatu = trim($_GET['bilatu'] ?? '');
    $sql = 'SELECT b.id, b.kategoriaId, b.izena, b.marka, b.modeloa, b.deskribapena, k.izena AS kategoria
            FROM baliabideak b JOIN kategoriak k ON k.id = b.kategoriaId';
    if ($bilatu !== '') {
        $sql .= ' WHERE b.izena LIKE :b1 OR b.marka LIKE :b2 OR b.modeloa LIKE :b3';
        $stmt = $pdo->prepare($sql . ' ORDER BY b.id');
        $term = '%' . $bilatu . '%';
        $stmt->execute(['b1' => $term, 'b2' => $term, 'b3' => $term]);
    } else {
        $stmt = $pdo->query($sql . ' ORDER BY b.id');
    }
    echo json_encode(['success' => true, 'baliabideak' => $stmt->fetchAll()]);
} catch (Throwable $e) {
    error_log($e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Errorea datuak kargatzean.']);
}
