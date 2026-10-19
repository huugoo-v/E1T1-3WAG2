<!DOCTYPE html>
<html lang="eu">
<head>
    <meta charset="UTF-8">
    <title>Inbentarioa - Alta</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>

    <!-- Header komuna -->
    <header>
        <a href="inbentario.php">Inbentarioa</a> | 
        <a href="erabiltzaileak.php">Erabiltzaileak</a> | 
        <a href="zerbitzaria.php">Zerbitzaria</a> | 
        <a href="login.php">Irten</a>
    </header>
    <hr>

    <h2>EKIPAMENDU BERRIA — ALTA EMAN / EDITATU</h2>

    <!-- JS bidez erakutsiko den errore mezua -->
    <p id="mezuErrorea" style="color: red;"></p>

    <!-- Formularioa -->
    <form id="formBaliabidea">

        <p>
            <label for="izena">Ekipamenduaren Izena (*):</label><br>
            <input type="text" name="izena" id="izena" placeholder="Ikasle NUC Ordenagailua">
        </p>

        <p>
            <label for="marka">Marka:</label><br>
            <input type="text" name="marka" id="marka" placeholder="Intel">
        </p>

        <p>
            <label for="modeloa">Modeloa:</label><br>
            <input type="text" name="modeloa" id="modeloa" placeholder="NUC 11 Pro Kit">
        </p>

        <p>
            <label for="kategoria_id">Kategoria (*):</label><br>
            <select name="kategoria_id" id="kategoria_id">
                <option value="1">Mahaigaineko ekipoa</option>
                <option value="2">Portatila</option>
                <option value="3">Periferikoak</option>
                <option value="4">Beste batzuk</option>
            </select>
        </p>

        <p>
            <label for="deskribapena">Deskribapena / Ezaugarriak (CPU, RAM, HDD, GPU...):</label><br>
            <textarea name="deskribapena" id="deskribapena" rows="3" placeholder="Intel Core i5-1135G7, 16GB RAM..."></textarea>
        </p>

        <p>
            <a href="inbentario.php">UTZI</a> | 
            <button type="submit">GORDE</button>
        </p>

    </form>

    <!-- Kanpoko JavaScript fitxategia kargatu -->
    <script src="js/sortuBaliabide.js"></script>

</body>
</html>
