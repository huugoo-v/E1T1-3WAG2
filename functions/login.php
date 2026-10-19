<?php
require_once __DIR__ . '/../config/db.php';   // DB fitxategia kargatu
require_once __DIR__ . '/../config/init.php'; // Init eta sesioak kargatu

header('Content-Type: application/json');     // Erantzuna JSON moduan bidaliko dela zehaztu

// Erabiltzailea eta pasahitza egiaztatzeko funtzioa
function loginEgiaztatu(PDO $konexioa, string $erabiltzaile, string $pasahitza): ?array
{
    $sql = "SELECT * FROM erabiltzaileak WHERE username = :username";
    $stmt = $konexioa->prepare($sql);         // SQL kontsulta prestatu
    $stmt->execute(['username' => $erabiltzaile]); 
    $erabiltzailea = $stmt->fetch();          // Erabiltzailearen datuak jaso

    if (!$erabiltzailea) {
        return null;                          // Erabiltzailea ez da existitzen
    }

    if (password_verify($pasahitza, $erabiltzailea['pasahitza'])) {
        session_regenerate_id(true);          // Session fixation prebenitu
        return $erabiltzailea;                // Pasahitza zuzena denean datuak itzuli
    }

    return null;                              // Pasahitza okerra bada
}

// POST bidezko bidalketa denean
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $erabiltzaile = trim($_POST['erabiltzaile'] ?? ''); // Erabiltzailea jaso
    $pasahitza    = trim($_POST['pasahitza'] ?? '');    // Pasahitza jaso

    // PHP Validazioa: Eremuak hutsik dauden egiaztatu
    if (empty($erabiltzaile) || empty($pasahitza)) {
        echo json_encode(['success' => false, 'message' => 'Eremuak ezin dira hutsik egon.']);
        exit();
    }

    $db = new DB();                           // DB objektua sortu
    $konexioa = $db->getKonexioa();           // DB konexioa lortu

    $user = loginEgiaztatu($konexioa, $erabiltzaile, $pasahitza); // Login-a egiaztatu

    if ($user) {
        // Saio aldagaiak gorde
        $_SESSION['user_id']      = $user['id'];
        $_SESSION['erabiltzaile'] = $user['username'];
        $_SESSION['username']     = $user['username'];
        $_SESSION['rol']          = $user['rol'];

        echo json_encode(['success' => true]); // Ondo egin dela erantzun
    } else {
        echo json_encode(['success' => false, 'message' => 'Erabiltzailea edo pasahitza okerrak.']); // Errorea erantzun
    }
    exit();
}