<?php

// Erabiltzaile berri bat gehitzen du. ID automatikoa da.
function sortuErabiltzaile(PDO $konexioa, string $erabiltzaile, string $pasahitza, string $rol = 'erabiltzailea'): bool
{
    $hash = password_hash($pasahitza, PASSWORD_DEFAULT);

    $sql = "INSERT INTO erabiltzaileak (username, pasahitza, rol) 
            VALUES (:erabiltzaile, :pasahitza, :rol)";

    $stmt = $konexioa->prepare($sql);
    return $stmt->execute([
        'erabiltzaile' => $erabiltzaile,
        'pasahitza'    => $hash,
        'rol'          => $rol,
    ]);
}
?>