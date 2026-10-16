<?php

// Erabiltzailea eta pasahitza egiaztatzen ditu eta sesioa seguru hasieratzen du.
function loginEgiaztatu(PDO $konexioa, string $erabiltzaile, string $pasahitza): ?array
{
    $sql = "SELECT * FROM erabiltzaileak WHERE username = :username";

    $stmt = $konexioa->prepare($sql);
    $stmt->execute(['username' => $erabiltzaile]); 

    $erabiltzailea = $stmt->fetch();

    if (!$erabiltzailea) {
        return null;
    }

    $hash = $erabiltzailea['pasahitza'];

    // Diapositibako baldintza bera:
    if (password_verify($pasahitza, $hash)) {

        session_regenerate_id(true);                  // Session fixation-en aurka
        
        $_SESSION['user_id'] = $erabiltzailea['id'];  // Erabiltzailearen IDa sesioan gorde

        return $erabiltzailea;                         // Erabiltzailearen datuak itzuli
    }

    return null;
}
?>