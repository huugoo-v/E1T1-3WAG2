<?php

// Baliabide bat ezabatzen du id-aren arabera.
function ezabatuBaliaide(PDO $konexioa, int $id): bool
{
    $sql = "DELETE FROM baliabideak WHERE id = :id";
    $stmt = $konexioa->prepare($sql);
    return $stmt->execute(['id' => $id]);
}

?>