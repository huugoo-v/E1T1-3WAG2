<?php
require_once __DIR__ . '/../config/init.php';
header('Content-Type: application/json; charset=utf-8');

// Erabiltzaile taula admin rola dutenek bakarrik kudeatu dezakete
adminEskatu();

const ROLAK = ['admin', 'user'];

try {
    $pdo = (new DB())->getKonexioa();

    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $stmt = $pdo->query("SELECT id, username, IF(rol = 'admin', 'admin', 'user') AS rol FROM erabiltzaileak ORDER BY username");
        echo json_encode(['success' => true, 'erabiltzaileak' => $stmt->fetchAll(), 'unekoId' => (int) $_SESSION['user_id']]);
        exit;
    }

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        jsonErantzun(405, ['success' => false, 'message' => 'Metodoa ez da onartzen.']);
    }

    $input = json_decode(file_get_contents('php://input'), true);
    if (!is_array($input)) {
        jsonErantzun(422, ['success' => false, 'message' => 'Eskaera baliogabea.']);
    }
    $ekintza = $input['ekintza'] ?? '';
    $id = filter_var($input['id'] ?? null, FILTER_VALIDATE_INT);

    // Admin kopurua (aukeratutako erabiltzailea kenduta)
    $besteAdminak = function (int $kenduId) use ($pdo): int {
        $stmt = $pdo->prepare("SELECT COUNT(*) FROM erabiltzaileak WHERE rol = 'admin' AND id <> :id");
        $stmt->execute(['id' => $kenduId]);
        return (int) $stmt->fetchColumn();
    };

    if ($ekintza === 'sortu' || $ekintza === 'aldatu') {
        $username = trim((string) ($input['username'] ?? ''));
        $pasahitza = (string) ($input['pasahitza'] ?? '');
        $rol = (string) ($input['rol'] ?? '');

        $erroreak = [];
        if (!preg_match('/^[A-Za-z0-9_.-]{3,50}$/', $username)) {
            $erroreak[] = 'Erabiltzailea 3-50 karakterekoa izan behar da (letrak, zenbakiak, _ . -).';
        }
        if (!in_array($rol, ROLAK, true)) {
            $erroreak[] = 'Rol baliogabea (admin edo user izan behar da).';
        }
        $pasahitzaEskatua = $ekintza === 'sortu' || $pasahitza !== '';
        if ($pasahitzaEskatua && (strlen($pasahitza) < 8 || strlen($pasahitza) > 72)) {
            $erroreak[] = 'Pasahitzak 8 eta 72 karaktere artean izan behar ditu.';
        }
        if ($ekintza === 'aldatu' && (!$id || $id < 1)) {
            $erroreak[] = 'ID baliogabea.';
        }
        if ($erroreak) {
            jsonErantzun(422, ['success' => false, 'message' => implode(' ', $erroreak)]);
        }

        if ($ekintza === 'sortu') {
            $stmt = $pdo->prepare('INSERT INTO erabiltzaileak (username, pasahitza, rol) VALUES (:u, :p, :r)');
            $stmt->execute(['u' => $username, 'p' => password_hash($pasahitza, PASSWORD_DEFAULT), 'r' => $rol]);
            echo json_encode(['success' => true]);
            exit;
        }

        // aldatu
        $stmt = $pdo->prepare('SELECT rol FROM erabiltzaileak WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $unekoRola = $stmt->fetchColumn();
        if ($unekoRola === false) {
            jsonErantzun(404, ['success' => false, 'message' => 'Erabiltzailea ez da aurkitu.']);
        }
        if ($unekoRola === 'admin' && $rol !== 'admin' && $besteAdminak($id) === 0) {
            jsonErantzun(409, ['success' => false, 'message' => 'Ezin da azken admin-aren rola kendu.']);
        }
        if ($pasahitza !== '') {
            $stmt = $pdo->prepare('UPDATE erabiltzaileak SET username=:u, pasahitza=:p, rol=:r WHERE id=:id');
            $stmt->execute(['u' => $username, 'p' => password_hash($pasahitza, PASSWORD_DEFAULT), 'r' => $rol, 'id' => $id]);
        } else {
            $stmt = $pdo->prepare('UPDATE erabiltzaileak SET username=:u, rol=:r WHERE id=:id');
            $stmt->execute(['u' => $username, 'r' => $rol, 'id' => $id]);
        }
        echo json_encode(['success' => true]);
        exit;
    }

    if ($ekintza === 'ezabatu') {
        if (!$id || $id < 1) {
            jsonErantzun(422, ['success' => false, 'message' => 'ID baliogabea.']);
        }
        if ($id === (int) $_SESSION['user_id']) {
            jsonErantzun(409, ['success' => false, 'message' => 'Ezin duzu zure burua ezabatu.']);
        }
        $stmt = $pdo->prepare('SELECT rol FROM erabiltzaileak WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $rola = $stmt->fetchColumn();
        if ($rola === false) {
            jsonErantzun(404, ['success' => false, 'message' => 'Erabiltzailea ez da aurkitu.']);
        }
        if ($rola === 'admin' && $besteAdminak($id) === 0) {
            jsonErantzun(409, ['success' => false, 'message' => 'Ezin da azken admin-a ezabatu.']);
        }
        $stmt = $pdo->prepare('DELETE FROM erabiltzaileak WHERE id = :id');
        $stmt->execute(['id' => $id]);
        echo json_encode(['success' => true]);
        exit;
    }

    jsonErantzun(422, ['success' => false, 'message' => 'Ekintza baliogabea.']);
} catch (PDOException $e) {
    if ($e->getCode() === '23000') {
        $mezua = str_contains($e->getMessage(), 'uq_erabiltzaileak_username')
            ? 'Erabiltzaile-izen hori hartuta dago.'
            : 'Ezin da ekintza burutu: erabiltzaileak mugimenduak ditu esleituta.';
        jsonErantzun(409, ['success' => false, 'message' => $mezua]);
    }
    error_log($e->getMessage());
    jsonErantzun(500, ['success' => false, 'message' => 'Errorea erabiltzaileak kudeatzean.']);
} catch (Throwable $e) {
    error_log($e->getMessage());
    jsonErantzun(500, ['success' => false, 'message' => 'Errorea erabiltzaileak kudeatzean.']);
}
