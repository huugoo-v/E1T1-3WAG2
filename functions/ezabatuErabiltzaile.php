<?php

// Erabiltzaile bat ezabatzen du id-aren arabera.
function ezabatuErabiltzaile(PDO $konexioa, int $id): bool
{
    $sql = "DELETE FROM erabiltzaileak WHERE id = :id"; //: segurua jartzeko
    $stmt = $konexioa->prepare($sql);
    return $stmt->execute(['id' => $id]); // segurua
}

?>