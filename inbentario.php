<?php
require_once __DIR__ . '/config/init.php';

// Sesioa hasi ez bada loginera itzuli
if (!isset($_SESSION['user_id'])) {
    header('Location: login.php');
    exit();
}
?>
<!DOCTYPE html>
<html lang="eu">
<head>
    <meta charset="UTF-8">
    <title>Inbentarioa</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <!-- Header komuna orrialde guztietan berdin erabiltzeko -->
    <header>
        <a href="inbentario.php">Inbentarioa</a>
        <a href="erabiltzaileak.php">Erabiltzaileak</a>
        <a href="zerbitzaria.php">Zerbitzaria</a>
        <a href="logout.php">Irten</a>
    </header>
    <hr>

    <h1>Inbentarioa</h1>

    <!-- Objektu berria sortzeko esteka -->
    <a href="objetuakSortu.php">+ Objektu Berria Sortu</a>
    <br><br>

    <!-- JS bidez erakutsiko den errore mezua -->
    <p id="mezuErrorea" style="color: red;"></p>

    <!-- Bilaketa formularioa -->
    <form id="bilatuForm">
        <input type="text" id="bilatu" placeholder="Bilatu...">
        <button type="submit">Iragazi</button>
        <a href="inbentario.php" id="garbitu">Garbitu</a>
    </form>

    <br>

    <!-- Zerrendaren taula (JS-k betetzen du) -->
    <table border="1">
        <thead>
            <tr>
                <th>Izena</th>
                <th>Marka</th>
                <th>Modeloa</th>
                <th>Kategoria</th>
                <th>Ezaugarriak</th>
                <th>Ekintzak</th>
            </tr>
        </thead>
        <tbody id="taulaGorputza"></tbody>
    </table>

    <!-- JS fitxategia -->
    <script src="js/inbentario.js"></script>
</body>
</html>