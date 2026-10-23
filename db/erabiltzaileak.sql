-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 21-10-2026 a las 14:04:46
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12
SET
  SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

START TRANSACTION;

SET
  time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;

/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;

/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;

/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `e1inbentarioa`
--
-- --------------------------------------------------------
--
-- Estructura de tabla para la tabla `erabiltzaileak`
--
CREATE DATABASE IF NOT EXISTS e1inbentarioa DEFAULT CHARACTER
SET
  utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;

USE e1inbentarioa;

CREATE TABLE
  `erabiltzaileak` (
    `id` int (11) NOT NULL,
    `username` varchar(50) NOT NULL,
    `pasahitza` varchar(255) NOT NULL,
    `rol` varchar(30) NOT NULL DEFAULT 'user'
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `erabiltzaileak`
--
INSERT INTO
  `erabiltzaileak` (`id`, `username`, `pasahitza`, `rol`)
VALUES
  (
    5,
    'Danel',
    '$2y$10$123456789012345678901uzyIHo1qeQfuj8ky7h/8Ma04yZy78hfy',
    'user'
  ),
  (
    6,
    'Anti',
    '$2y$10$123456789012345678901uzyIHo1qeQfuj8ky7h/8Ma04yZy78hfy',
    'user'
  ),
  (
    7,
    'Joseba',
    '$2y$10$123456789012345678901uzyIHo1qeQfuj8ky7h/8Ma04yZy78hfy',
    'admin'
  ),
  (
    8,
    'Hugo',
    '$2y$10$123456789012345678901uzyIHo1qeQfuj8ky7h/8Ma04yZy78hfy',
    'user'
  );

--
-- Índices para tablas volcadas
--
--
-- Indices de la tabla `erabiltzaileak`
--
ALTER TABLE `erabiltzaileak` ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `uq_erabiltzaileak_username` (`username`);

--
-- AUTO_INCREMENT de las tablas volcadas
--
--
-- AUTO_INCREMENT de la tabla `erabiltzaileak`
--
ALTER TABLE `erabiltzaileak` MODIFY `id` int (11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 9;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;

/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;