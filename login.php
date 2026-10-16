<?php
require_once __DIR__ . '/config/init.php';
require_once __DIR__ . '/functions/login.php';


$db = new DB();                    // DB objektua sortu
$konexioa = $db->getKonexioa();    // konexioa hartu

$errorea = "";
$ondo = false;

if (isset($_POST['sartu'])) {      // formularioa bidali bada
    $erabiltzaile = trim($_POST['erabiltzaile']);  // erabiltzailea
    $pasahitza    = trim($_POST['pasahitza']);     // pasahitza

    // Hutsik badaude, errorea
    if (empty($erabiltzaile) || empty($pasahitza)) {
        $errorea = "Eremuak ezin dira hutsik egon.";
    
    } else {
        $user = loginEgiaztatu($konexioa, $erabiltzaile, $pasahitza);  // egiaztatu

        if ($user) { // Saio aldagaiak gorde (inbentarioa.php-k egiaztatu ahal izateko)
            
            $_SESSION['user_id']      = $user['id'];
            $_SESSION['erabiltzaile'] = $user['username'];
            $_SESSION['username']     = $user['username'];
            $_SESSION['rol']          = $user['rol'];

            // Inbentariora eraman
            header('Location: inbentario.php');
            exit(); 

        } else {
            $errorea = "Erabiltzailea edo pasahitza okerrak."; 
        }
    }
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

<?php if ($ondo): ?>
    
    <h2>Ongi etorri, <?php echo htmlspecialchars($_SESSION['erabiltzaile']); ?> </h2>
    <p>Rola: <?php echo htmlspecialchars($_SESSION['rol']); ?></p>
<?php else: ?>

    <h2>Saioa hasi</h2>

    <!----------- Errorea badago ------------>
    <?php if ($errorea) echo "<p class='errorea'>$errorea</p>"; ?>

    <form method="POST" id="loginForm">
        <label>Erabiltzailea:</label>
        <input type="text" name="erabiltzaile" id="erabiltzaile"><br><br>

        <label>Pasahitza:</label>
        <input type="password" name="pasahitza" id="pasahitza"><br><br>

        <input type="submit" name="sartu" value="Sartu">
    </form>

<?php endif; ?>

<script src="js/login.js"></script>
</body>
</html>