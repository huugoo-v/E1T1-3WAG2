<?php

require_once __DIR__ . '/config/db.php';
require_once __DIR__ . '/config/init.php';

//Sesioa hasi ez bada loginera itzuli
if(!isset($_SESSION['user_id'])) {      
   header('Location: login.php');
    exit();
}

$db = new DB();
$konexioa = $db->getKonexioa();

// GET bidezko parametroak jaso
$bilatu = $_GET['bilatu'] ?? '';            // Bilatutako testua jaso
$kategoria = $_GET['kategoria'] ?? '';      // Aukeratutako kategoria jaso

$stmt = $konexioa->query("SELECT * FROM baliabideak");
$baliabideak = $stmt->fetchAll();

?>

<!DOCTYPE html>
<lang="eu">
<head>
    <meta charset="UTF-8">
    <title>Inbentarioa</title>
</head>
<body>
    <!-- Header komuna orrialde guztietan berdin erabiltzeko -->
    <header>
        <a href="inbentario.php">Inbentarioa</a> 
        <a href="erabiltzaileak.php">Erabiltzaileak</a>  
        <a href="zerbitzaria.php">Zerbitzaria</a>  
        <a href="login.php">Irten</a>
    </header>
      <hr>    
