-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 21, 2026 at 08:21 AM
-- Server version: 10.11.14-MariaDB-0ubuntu0.24.04.1
-- PHP Version: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS e1inbentarioa DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE e1inbentarioa;

--
-- Database: `e1inbentarioa`
--

-- --------------------------------------------------------

--
-- Table structure for table `baliabideak`
--

CREATE TABLE `baliabideak` (
  `id` int(11) NOT NULL,
  `kategoriaId` int(11) NOT NULL,
  `izena` varchar(150) NOT NULL,
  `deskribapena` text DEFAULT NULL,
  `marka` varchar(100) DEFAULT NULL,
  `modeloa` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `baliabideak`
--

INSERT INTO `baliabideak` (`id`, `kategoriaId`, `izena`, `deskribapena`, `marka`, `modeloa`) VALUES
(8, 1, 'ikasle', 'adawdwd', 'awdaw', 'awdwad'),
(9, 2, 'Hugo', 'Holi', 'Mason', 'pene'),
(12, 1, 'dawdad', 'adawdwad', 'adawda', 'dawdwadawd'),
(13, 1, 'awddwa', 'awdawd', 'adawd', 'awdawda'),
(14, 1, 'ad', 'awdawd', 'adawd', 'adawd');

-- --------------------------------------------------------

--
-- Table structure for table `erabiltzaileak`
--

CREATE TABLE `erabiltzaileak` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `pasahitza` varchar(255) NOT NULL,
  `rol` varchar(30) NOT NULL DEFAULT 'teknikaria'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `erabiltzaileak`
--

INSERT INTO `erabiltzaileak` (`id`, `username`, `pasahitza`, `rol`) VALUES
(5, 'Danel', '$2y$10$123456789012345678901uzyIHo1qeQfuj8ky7h/8Ma04yZy78hfy', 'erabiltzailea'),
(6, 'Anti', '$2y$10$123456789012345678901uzyIHo1qeQfuj8ky7h/8Ma04yZy78hfy', 'erabiltzailea'),
(7, 'Joseba', '$2y$10$123456789012345678901uzyIHo1qeQfuj8ky7h/8Ma04yZy78hfy', 'erabiltzailea'),
(8, 'Hugo', '$2y$10$123456789012345678901uzyIHo1qeQfuj8ky7h/8Ma04yZy78hfy', 'erabiltzailea');

-- --------------------------------------------------------

--
-- Table structure for table `gailuak`
--

CREATE TABLE `gailuak` (
  `id` int(11) NOT NULL,
  `baliabideId` int(11) NOT NULL,
  `etiketa` varchar(50) NOT NULL,
  `erosketaData` date DEFAULT NULL,
  `egoera` varchar(50) DEFAULT 'Operatiboa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gelak`
--

CREATE TABLE `gelak` (
  `id` int(11) NOT NULL,
  `izena` varchar(100) NOT NULL,
  `taldea` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kategoriak`
--

CREATE TABLE `kategoriak` (
  `id` int(11) NOT NULL,
  `izena` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kategoriak`
--

INSERT INTO `kategoriak` (`id`, `izena`) VALUES
(1, 'Mahaigaineko ekipoa'),
(2, 'Portatila'),
(3, 'Periferikoak'),
(4, 'Beste batzuk');

-- --------------------------------------------------------

--
-- Table structure for table `mugimenduak`
--

CREATE TABLE `mugimenduak` (
  `id` int(11) NOT NULL,
  `gelaId` int(11) NOT NULL,
  `gailuId` int(11) NOT NULL,
  `erabiltzaileId` int(11) NOT NULL,
  `hasieraData` date NOT NULL,
  `amaieraData` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `baliabideak`
--
ALTER TABLE `baliabideak`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_baliabideak_kategoriak` (`kategoriaId`);

--
-- Indexes for table `erabiltzaileak`
--
ALTER TABLE `erabiltzaileak`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_erabiltzaileak_username` (`username`);

--
-- Indexes for table `gailuak`
--
ALTER TABLE `gailuak`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_gailuak_etiketa` (`etiketa`),
  ADD KEY `fk_gailuak_baliabideak` (`baliabideId`);

--
-- Indexes for table `gelak`
--
ALTER TABLE `gelak`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kategoriak`
--
ALTER TABLE `kategoriak`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mugimenduak`
--
ALTER TABLE `mugimenduak`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_mugimenduak_gelak` (`gelaId`),
  ADD KEY `fk_mugimenduak_gailuak` (`gailuId`),
  ADD KEY `fk_mugimenduak_erabiltzaileak` (`erabiltzaileId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `baliabideak`
--
ALTER TABLE `baliabideak`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `erabiltzaileak`
--
ALTER TABLE `erabiltzaileak`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `gailuak`
--
ALTER TABLE `gailuak`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gelak`
--
ALTER TABLE `gelak`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kategoriak`
--
ALTER TABLE `kategoriak`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `mugimenduak`
--
ALTER TABLE `mugimenduak`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `baliabideak`
--
ALTER TABLE `baliabideak`
  ADD CONSTRAINT `fk_baliabideak_kategoriak` FOREIGN KEY (`kategoriaId`) REFERENCES `kategoriak` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `gailuak`
--
ALTER TABLE `gailuak`
  ADD CONSTRAINT `fk_gailuak_baliabideak` FOREIGN KEY (`baliabideId`) REFERENCES `baliabideak` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `mugimenduak`
--
ALTER TABLE `mugimenduak`
  ADD CONSTRAINT `fk_mugimenduak_erabiltzaileak` FOREIGN KEY (`erabiltzaileId`) REFERENCES `erabiltzaileak` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mugimenduak_gailuak` FOREIGN KEY (`gailuId`) REFERENCES `gailuak` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_mugimenduak_gelak` FOREIGN KEY (`gelaId`) REFERENCES `gelak` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
