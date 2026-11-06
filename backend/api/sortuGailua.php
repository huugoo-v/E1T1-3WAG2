<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

saioaEskatu();
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Metodoa ez da onartzen.']);
    exit;
}

$id = filter_input(INPUT_POST, 'id', FILTER_VALIDATE_INT);
$etiketa = trim($_POST['etiketa'] ?? '');
$izena = trim($_POST['izena'] ?? '');
$marka = trim($_POST['marka'] ?? '');
$modeloa = trim($_POST['modeloa'] ?? '');
$kategoriaId = filter_input(INPUT_POST, 'kategoria_id', FILTER_VALIDATE_INT);
$deskribapena = trim($_POST['deskribapena'] ?? '');
$gelaId = filter_input(INPUT_POST, 'gela_id', FILTER_VALIDATE_INT);
$egoera = trim($_POST['egoera'] ?? '');
$erosketaData = trim($_POST['erosketa_data'] ?? '');
if ($egoera === '') {
    $egoera = 'Operatiboa';
}

// Zerbitzariaren aldeko baliozkotzea (bezeroarena ez da nahikoa)
$erroreak = [];
if ($etiketa === '' || mb_strlen($etiketa) > 50) {
    $erroreak[] = 'Etiketa derrigorrezkoa da (gehienez 50 karaktere).';
}
if ($izena === '' || mb_strlen($izena) > 150) {
    $erroreak[] = 'Izena derrigorrezkoa da (gehienez 150 karaktere).';
}
if (mb_strlen($marka) > 100) {
    $erroreak[] = 'Marka luzeegia da (gehienez 100 karaktere).';
}
if (mb_strlen($modeloa) > 100) {
    $erroreak[] = 'Modeloa luzeegia da (gehienez 100 karaktere).';
}
if (mb_strlen($deskribapena) > 2000) {
    $erroreak[] = 'Deskribapena luzeegia da (gehienez 2000 karaktere).';
}
if (mb_strlen($egoera) > 50) {
    $erroreak[] = 'Egoera luzeegia da (gehienez 50 karaktere).';
}
if (!$kategoriaId || $kategoriaId < 1) {
    $erroreak[] = 'Kategoria zuzena aukeratu behar da.';
}
if ($erosketaData !== '') {
    $d = DateTime::createFromFormat('!Y-m-d', $erosketaData);
    if (!$d || $d->format('Y-m-d') !== $erosketaData) {
        $erroreak[] = 'Erosketa-data baliogabea da.';
    }
}
if (!$id && (!$gelaId || $gelaId < 1)) {
    $erroreak[] = 'Gela aukeratu behar da.';
}
if ($erroreak) {
    jsonErantzun(422, ['success' => false, 'message' => implode(' ', $erroreak)]);
}

$pdo = (new DB())->getKonexioa();

/** Transakzioa bertan behera utzi eta errorea erantzun. */
$utzi = function (int $kodea, string $mezua) use ($pdo): void {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    jsonErantzun($kodea, ['success' => false, 'message' => $mezua]);
};

try {
    $pdo->beginTransaction();

    $stmt = $pdo->prepare('SELECT 1 FROM kategoriak WHERE id = :id');
    $stmt->execute(['id' => $kategoriaId]);
    if (!$stmt->fetchColumn()) {
        $utzi(422, 'Kategoria ez da existitzen.');
    }

    // Etiketa bakarra da: beste gailu batek ez dezake erabili
    $stmt = $pdo->prepare('SELECT id FROM gailuak WHERE etiketa = :etiketa');
    $stmt->execute(['etiketa' => $etiketa]);
    $berdina = $stmt->fetchColumn();
    if ($berdina !== false && (int) $berdina !== (int) $id) {
        $utzi(409, 'Etiketa hori beste gailu batek erabiltzen du.');
    }

    $zaharra = null;
    if ($id) {
        $stmt = $pdo->prepare('SELECT baliabideId FROM gailuak WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $zaharra = $stmt->fetchColumn();
        if ($zaharra === false) {
            $utzi(404, 'Gailua ez da aurkitu.');
        }
    } else {
        $stmt = $pdo->prepare('SELECT 1 FROM gelak WHERE id = :id');
        $stmt->execute(['id' => $gelaId]);
        if (!$stmt->fetchColumn()) {
            $utzi(422, 'Gela ez da existitzen.');
        }
    }

    // Gailuaren "mota" (izena, marka, modeloa, kategoria, deskribapena): lehendik badago erabili, bestela sortu
    $stmt = $pdo->prepare("SELECT id FROM baliabideak
                           WHERE kategoriaId = :kategoria AND izena = :izena
                             AND COALESCE(marka, '') = :marka AND COALESCE(modeloa, '') = :modeloa
                             AND COALESCE(deskribapena, '') = :deskribapena
                           ORDER BY id LIMIT 1");
    $stmt->execute([
        'kategoria' => $kategoriaId, 'izena' => $izena, 'marka' => $marka,
        'modeloa' => $modeloa, 'deskribapena' => $deskribapena,
    ]);
    $baliabideId = $stmt->fetchColumn();
    if ($baliabideId === false) {
        $stmt = $pdo->prepare('INSERT INTO baliabideak (kategoriaId, izena, marka, modeloa, deskribapena)
                               VALUES (:kategoria, :izena, :marka, :modeloa, :deskribapena)');
        $stmt->execute([
            'kategoria' => $kategoriaId, 'izena' => $izena, 'marka' => $marka,
            'modeloa' => $modeloa, 'deskribapena' => $deskribapena,
        ]);
        $baliabideId = (int) $pdo->lastInsertId();
    }

    if ($id) {
        $stmt = $pdo->prepare('UPDATE gailuak
                               SET baliabideId = :baliabide, etiketa = :etiketa, erosketaData = :data, egoera = :egoera
                               WHERE id = :id');
        $stmt->execute([
            'baliabide' => $baliabideId, 'etiketa' => $etiketa,
            'data' => $erosketaData === '' ? null : $erosketaData, 'egoera' => $egoera, 'id' => $id,
        ]);
        $gailuId = $id;

        // Mota zaharrak gailurik gabe geratu bada, ez da inon agertzen: ezabatu
        if ((int) $zaharra !== (int) $baliabideId) {
            $stmt = $pdo->prepare('DELETE FROM baliabideak
                                   WHERE id = :zaharra AND NOT EXISTS (SELECT 1 FROM gailuak WHERE baliabideId = :zaharra2)');
            $stmt->execute(['zaharra' => $zaharra, 'zaharra2' => $zaharra]);
        }
    } else {
        $stmt = $pdo->prepare('INSERT INTO gailuak (baliabideId, etiketa, erosketaData, egoera)
                               VALUES (:baliabide, :etiketa, :data, :egoera)');
        $stmt->execute([
            'baliabide' => $baliabideId, 'etiketa' => $etiketa,
            'data' => $erosketaData === '' ? null : $erosketaData, 'egoera' => $egoera,
        ]);
        $gailuId = (int) $pdo->lastInsertId();

        // Hasierako esleipena: gailua aukeratutako gelan geratzen da
        $stmt = $pdo->prepare('INSERT INTO mugimenduak (gelaId, gailuId, erabiltzaileId, hasieraData)
                               VALUES (:gela, :gailu, :erabiltzailea, CURDATE())');
        $stmt->execute(['gela' => $gelaId, 'gailu' => $gailuId, 'erabiltzailea' => (int) $_SESSION['user_id']]);
    }

    $pdo->commit();
    echo json_encode(['success' => true, 'id' => $gailuId]);
} catch (PDOException $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    // 23000: etiketa bikoiztua (bi eskaera aldi berean)
    if ($e->getCode() === '23000') {
        jsonErantzun(409, ['success' => false, 'message' => 'Etiketa hori beste gailu batek erabiltzen du.']);
    }
    error_log($e->getMessage());
    jsonErantzun(500, ['success' => false, 'message' => 'Errorea gailua gordetzean.']);
} catch (Throwable $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    error_log($e->getMessage());
    jsonErantzun(500, ['success' => false, 'message' => 'Errorea gailua gordetzean.']);
}
