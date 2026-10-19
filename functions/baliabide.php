<?php
require_once __DIR__ . '/../config/init.php'; // Sesioa eta DB kargatu

header('Content-Type: application/json');

// Saioa hasita ez badago
if (!isset($_SESSION['user_id'])) {
    echo json_encode(['success' => false, 'saioa' => false, 'message' => 'Saioa ez dago hasita.']);
    exit();
}

try {
    $db = new DB();
    $konexioa = $db->getKonexioa();

    $bilatu = trim($_GET['bilatu'] ?? '');

    // kategoriak taulako izena lortzeko JOIN erabiltzen da (baliabideak-ek kategoriaId bakarrik gordetzen du)
    $sql = "SELECT b.id, b.izena, b.marka, b.modeloa, b.deskribapena, k.izena AS kategoria
            FROM baliabideak b
            JOIN kategoriak k ON k.id = b.kategoriaId";

    if ($bilatu !== '') {
        // Izenaren, markaren edo modeloaren arabera bilatu
        $stmt = $konexioa->prepare(
            $sql . " WHERE b.izena LIKE :b1 OR b.marka LIKE :b2 OR b.modeloa LIKE :b3 ORDER BY b.id"
        );
        $stmt->execute(['b1' => "%$bilatu%", 'b2' => "%$bilatu%", 'b3' => "%$bilatu%"]);
    } else {
        $stmt = $konexioa->query($sql . " ORDER BY b.id");
    }

    echo json_encode(['success' => true, 'baliabideak' => $stmt->fetchAll()]);
} catch (Throwable $e) {
    error_log($e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Errorea datuak kargatzean.']);
}