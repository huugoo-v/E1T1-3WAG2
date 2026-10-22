<?php
ini_set('session.cookie_httponly', '1');
ini_set('session.cookie_secure', !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' ? '1' : '0');
ini_set('session.cookie_samesite', 'Strict');
ini_set('session.gc_maxlifetime', '3600');
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}
require_once __DIR__ . '/db.php';
