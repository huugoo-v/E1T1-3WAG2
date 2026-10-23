<?php
// Saioaren konfigurazio segurua
ini_set('session.use_strict_mode', '1');
ini_set('session.use_only_cookies', '1');
ini_set('session.cookie_httponly', '1');
ini_set('session.cookie_secure', !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' ? '1' : '0');
ini_set('session.cookie_samesite', 'Strict');
ini_set('session.gc_maxlifetime', '3600');

// Erantzunak ez dira inoiz cachean gordeko (saioa itxi ondoren "atzera" botoiak ez du daturik erakutsiko)
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');
header('X-Content-Type-Options: nosniff');

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}
require_once __DIR__ . '/db.php';

const SAIOA_IRAUPENA = 3600; // segundutan: jarduerarik gabeko denbora maximoa

function saioaHustu(): void
{
    $_SESSION = [];
    if (ini_get('session.use_cookies')) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000, $params['path'], $params['domain'], $params['secure'], $params['httponly']);
    }
    if (session_status() === PHP_SESSION_ACTIVE) {
        session_destroy();
    }
}

function jsonErantzun(int $kodea, array $datuak): void
{
    http_response_code($kodea);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($datuak);
    exit;
}

/**
 * Saio baliozkorik ez badago, 401 erantzuten du eta scripta geldiarazten du.
 * Saioa dagoen bakoitzean datu-basearekin egiaztatzen da: erabiltzailea ezabatu bada
 * edo rola aldatu bazaio, aldaketa berehala aplikatzen da.
 */
function saioaEskatu(): void
{
    $kanpoan = fn() => jsonErantzun(401, ['success' => false, 'saioa' => false, 'message' => 'Saioa hasi behar duzu.']);

    if (!isset($_SESSION['user_id'])) {
        $kanpoan();
    }
    if (isset($_SESSION['azkenJarduera']) && time() - (int) $_SESSION['azkenJarduera'] > SAIOA_IRAUPENA) {
        saioaHustu();
        $kanpoan();
    }

    try {
        $stmt = (new DB())->getKonexioa()->prepare('SELECT id, username, rol FROM erabiltzaileak WHERE id = :id');
        $stmt->execute(['id' => (int) $_SESSION['user_id']]);
        $user = $stmt->fetch();
    } catch (Throwable $e) {
        error_log($e->getMessage());
        jsonErantzun(500, ['success' => false, 'message' => 'Errorea saioa egiaztatzean.']);
    }

    if (!$user) {
        saioaHustu();
        $kanpoan();
    }

    $_SESSION['azkenJarduera'] = time();
    $_SESSION['username'] = $user['username'];
    $_SESSION['rol'] = $user['rol'] === 'admin' ? 'admin' : 'user';
}

/** Saioa eta admin rola eskatzen ditu. Bestela 401/403. */
function adminEskatu(): void
{
    saioaEskatu();
    if (($_SESSION['rol'] ?? '') !== 'admin') {
        jsonErantzun(403, ['success' => false, 'saioa' => true, 'baimenik' => false, 'message' => 'Ez duzu baimenik ekintza hau egiteko.']);
    }
}
