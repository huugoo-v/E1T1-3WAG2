<?php
require_once __DIR__ . '/config/init.php'; // Sesioa kargatu (session_start)

// 1. Sesioan gorde diren aldagai guztiak ezabatu
session_unset();

// 2. Sesioa bera amaitu
session_destroy();

// 3. Sesio cookie-a nabigatzailetik ezabatu (modu seguruan)
setcookie(session_name(), '', time() - 3600, '/', '', true, true);

// 4. Login orrialdera bideratu
header('Location: login.php');
exit();
?>
