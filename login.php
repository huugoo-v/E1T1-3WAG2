<?php
require_once __DIR__ . '/config/init.php';

$error = "";

if (isset($_POST['sartu'])) {
    $usuario  = trim($_POST['usuario']);
    $password = trim($_POST['password']);

    // Comprobar que no estén vacíos
    if (empty($usuario) || empty($password)) {
        $error = "No puedes dejar los campos vacíos.";
    } else {
        $sql = "SELECT * FROM erabiltzaileak WHERE user='$user' AND password='$password'";
        $resultado = mysqli_query($conexion, $sql);

        if (mysqli_num_rows($resultado) > 0) {
            $_SESSION['user'] = $user;
            header("Location: panel.php");
            exit;
        } else {
            $error = "Usuario o contraseña incorrectos.";
        }
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
    <h2>Sesioa Ireki</h2>

    <?php if ($error) echo "<p style='color:red'>$error</p>"; ?>

    <form method="POST">
        Erabiltzailea: <input type="text" name="usuario"><br><br>
        Pasahitza: <input type="password" name="password"><br><br>
        <input type="submit" name="entrar" value="Entrar">
    </form>
</body>
</html>