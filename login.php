<?php
require_once __DIR__ . '/config/init.php';

// Saioa hasita badago, inbentariora joan zuzenean
if (isset($_SESSION['user_id'])) {
    header('Location: inbentario.php');
    exit();
}
?>

<!DOCTYPE html>
<html lang="eu">
<head>
    <meta charset="UTF-8">
    <title>Saioa hasi</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>

    <h2>Saioa hasi</h2>

    <!-- Errore mezua bistaratzeko testua -->
    <p id="errorea" style="color: red;"></p>

    <!-- Formulario con method="POST" por seguridad -->
   <form id="loginForm" method="POST">
        <p>
            <label for="erabiltzaile">Erabiltzailea:</label><br>
            <input type="text" name="erabiltzaile" id="erabiltzaile" required>
        </p>

        <p>
            <label for="pasahitza">Pasahitza:</label><br>
            <input type="password" name="pasahitza" id="pasahitza" required>
        </p>

        <p>
            <button type="submit">Sartu</button>
        </p>
    </form>

    <!-- JS fitxategia -->
    <script src="js/login.js"></script>
</body>
</html>