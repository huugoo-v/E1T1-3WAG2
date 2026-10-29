-- =====================================================================
--  GELAK: MATERIAL REAL ASIGNADO A CADA SALA
--  Proyecto E1T1-3WAG2  ·  base de datos: e1inbentarioa
--
--  Crea las unidades fisicas (tabla gailuak, cada una con su ETIQUETA unica)
--  de los 40 objetos del inventario y las asigna a su sala (tabla mugimenduak).
--  Despues, cada unidad se puede mover de sala desde la pagina de la sala.
--
--  Reparto (337 unidades en total):
--    Gela 1     65 unidades
--    Gela 2     53 unidades
--    Gela 3     54 unidades
--    Gela 4     55 unidades
--    Gela 5     35 unidades
--    Mintegia   44 unidades
--    Biltegia   31 unidades
--
--  Criterio: cada sala recibe lo que le corresponde por su grupo
--    Gela 1 y 2 (DAW)         -> puestos de alumnos (PC, pantalla, teclado, raton) + proyector, switch, WiFi, SAI
--    Gela 3 (Administrazioa)  -> PCs de oficina, todo en uno, impresoras y escaneres
--    Gela 4 (Sareak)          -> mini PCs, servidores, switches, routers, puntos WiFi
--    Gela 5 (Irakasleak)      -> portatiles de profesorado, docks, pantallas, webcams
--    Mintegia                 -> estaciones de trabajo, portatiles variados, Raspberry Pi, Arduino
--    Biltegia                 -> material de repuesto (2 unidades en reparacion)
--  Los 40 objetos del inventario aparecen en alguna sala.
--
--  Como usarlo (phpMyAdmin): pestaña SQL -> pegar todo -> Continuar.
--  Se puede ejecutar varias veces: lo que ya existe no se duplica y una unidad
--  que ya esta en una sala NO se mueve (para eso esta el boton "Mugitu").
-- =====================================================================

USE e1inbentarioa;

-- ---------------------------------------------------------------------
-- 1) AJUSTES
-- ---------------------------------------------------------------------
-- Usuario que figurara como autor de la asignacion inicial: 'Joseba' si existe;
-- si no, el primer administrador.
SET @erabiltzaile_id := COALESCE(
  (SELECT id FROM erabiltzaileak WHERE username = 'Joseba'),
  (SELECT MIN(id) FROM erabiltzaileak WHERE rol = 'admin')
);
SET @hasiera_data := CURDATE();
SELECT @erabiltzaile_id AS erabiltzaile_id_aukeratua;  -- no debe salir NULL

-- ---------------------------------------------------------------------
-- 2) SALAS: las 7 salas del proyecto (Gela 1-5, Mintegia y Biltegia).
--    Solo se crean las que falten, buscando por nombre. La pagina "Gelak" ya no
--    crea salas por su cuenta: se crean y se borran desde ella con los botones.
-- ---------------------------------------------------------------------
INSERT INTO gelak (izena, taldea)
SELECT s.izena, s.taldea
FROM (
  SELECT 'Gela 1' AS izena, 'DAW' AS taldea
  UNION ALL SELECT 'Gela 2', 'DAW'
  UNION ALL SELECT 'Gela 3', 'Administrazioa'
  UNION ALL SELECT 'Gela 4', 'Sareak'
  UNION ALL SELECT 'Gela 5', 'Irakasleak'
  UNION ALL SELECT 'Mintegia', 'Informatika mintegia'
  UNION ALL SELECT 'Biltegia', 'Biltegia'
) s
WHERE NOT EXISTS (SELECT 1 FROM gelak g WHERE g.izena = s.izena);

-- ---------------------------------------------------------------------
-- 3) LISTA DE UNIDADES (una fila = una unidad fisica)
-- ---------------------------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS tmp_inbentarioa;
CREATE TEMPORARY TABLE tmp_inbentarioa (
  gela          varchar(100) NOT NULL,
  kategoria     varchar(100) NOT NULL,
  izena         varchar(150) NOT NULL,
  marka         varchar(100) DEFAULT NULL,
  modeloa       varchar(100) DEFAULT NULL,
  deskribapena  text         DEFAULT NULL,
  etiketa       varchar(50)  NOT NULL,
  erosketaData  date         DEFAULT NULL,
  egoera        varchar(50)  DEFAULT 'Operatiboa',
  PRIMARY KEY (etiketa)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

INSERT INTO tmp_inbentarioa
  (gela, kategoria, izena, marka, modeloa, deskribapena, etiketa, erosketaData, egoera)
VALUES
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-01', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-02', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-03', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-04', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-05', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-06', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-07', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-08', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-09', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-10', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-11', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-12', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-13', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PCHP-14', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-01', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-02', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-03', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-04', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-05', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-06', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-07', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-08', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-09', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-10', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-11', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-12', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-13', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G1-MOND-14', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-01', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-02', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-03', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-04', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-05', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-06', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-07', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-08', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-09', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-10', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-11', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-12', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-13', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G1-TEK-14', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-01', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-02', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-03', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-04', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-05', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-06', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-07', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-08', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-09', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-10', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-11', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-12', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-13', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'G1-SAG-14', '2023-09-04', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Web-kamera', 'Logitech', 'C920 HD Pro', 'Full HD 1080p, mikrofono estereoa', 'G1-CAM-01', '2022-03-14', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G1-AUR-01', '2022-03-14', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G1-AUR-02', '2022-03-14', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G1-AUR-03', '2022-03-14', 'Operatiboa'),
  ('Gela 1', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G1-AUR-04', '2022-03-14', 'Operatiboa'),
  ('Gela 1', 'Beste batzuk', 'Proiektorea', 'Epson', 'EB-X49', 'XGA, 3600 lumen, HDMI', 'G1-PRO-01', '2021-09-20', 'Operatiboa'),
  ('Gela 1', 'Beste batzuk', 'Switch-a', 'TP-Link', 'TL-SG1024', '24 ataka Gigabit, kudeaketarik gabea', 'G1-SWT-01', '2022-02-07', 'Operatiboa'),
  ('Gela 1', 'Beste batzuk', 'Wi-Fi sarbide-puntua', 'Ubiquiti', 'UniFi U6 Lite', 'Wi-Fi 6, PoE', 'G1-AP-01', '2023-03-08', 'Operatiboa'),
  ('Gela 1', 'Beste batzuk', 'SAI', 'APC', 'Back-UPS BX700U', '700 VA, 4 irteera, USB', 'G1-SAI-01', '2022-02-07', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-01', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-02', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-03', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-04', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-05', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-06', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-07', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-08', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-09', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-10', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-11', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-12', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-13', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'G2-PCLE-14', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-01', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-02', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-03', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-04', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-05', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-06', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-07', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-08', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-09', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-10', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-11', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-12', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-13', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G2-MONH-14', '2023-02-20', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-01', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-02', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-03', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-04', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-05', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-06', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-07', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-08', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-09', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-10', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-11', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-12', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-13', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G2-KIT-14', '2022-09-12', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Taula grafikoa', 'Wacom', 'Intuos S', 'Marrazteko taula, USB', 'G2-TAB-01', '2023-05-22', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Taula grafikoa', 'Wacom', 'Intuos S', 'Marrazteko taula, USB', 'G2-TAB-02', '2023-05-22', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Web-kamera', 'Logitech', 'C920 HD Pro', 'Full HD 1080p, mikrofono estereoa', 'G2-CAM-01', '2022-03-14', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G2-AUR-01', '2022-03-14', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G2-AUR-02', '2022-03-14', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G2-AUR-03', '2022-03-14', 'Operatiboa'),
  ('Gela 2', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G2-AUR-04', '2022-03-14', 'Operatiboa'),
  ('Gela 2', 'Beste batzuk', 'Proiektorea', 'Epson', 'EB-X49', 'XGA, 3600 lumen, HDMI', 'G2-PRO-01', '2021-09-20', 'Operatiboa'),
  ('Gela 2', 'Beste batzuk', 'Switch-a', 'TP-Link', 'TL-SG1024', '24 ataka Gigabit, kudeaketarik gabea', 'G2-SWT-01', '2022-02-07', 'Operatiboa'),
  ('Gela 2', 'Beste batzuk', 'Wi-Fi sarbide-puntua', 'Ubiquiti', 'UniFi U6 Lite', 'Wi-Fi 6, PoE', 'G2-AP-01', '2023-03-08', 'Operatiboa'),
  ('Gela 2', 'Beste batzuk', 'SAI', 'APC', 'Back-UPS BX700U', '700 VA, 4 irteera, USB', 'G2-SAI-01', '2022-02-07', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD', 'G3-PCDE-01', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD', 'G3-PCDE-02', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD', 'G3-PCDE-03', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD', 'G3-PCDE-04', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD', 'G3-PCDE-05', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD', 'G3-PCDE-06', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD', 'G3-PCDE-07', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD', 'G3-PCDE-08', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD', 'G3-PCDE-09', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD', 'G3-PCDE-10', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Dena batean ordenagailua', 'HP', 'ProOne 440 G9', '23,8 hazbeteko pantaila, Core i5, 16 GB RAM', 'G3-AIO-01', '2024-01-22', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Dena batean ordenagailua', 'HP', 'ProOne 440 G9', '23,8 hazbeteko pantaila, Core i5, 16 GB RAM', 'G3-AIO-02', '2024-01-22', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Dena batean ordenagailua', 'HP', 'ProOne 440 G9', '23,8 hazbeteko pantaila, Core i5, 16 GB RAM', 'G3-AIO-03', '2024-01-22', 'Operatiboa'),
  ('Gela 3', 'Mahaigaineko ekipoa', 'Dena batean ordenagailua', 'HP', 'ProOne 440 G9', '23,8 hazbeteko pantaila, Core i5, 16 GB RAM', 'G3-AIO-04', '2024-01-22', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G3-MOND-01', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G3-MOND-02', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G3-MOND-03', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G3-MOND-04', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G3-MOND-05', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G3-MOND-06', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G3-MOND-07', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G3-MOND-08', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G3-MOND-09', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'G3-MOND-10', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G3-TEK-01', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G3-TEK-02', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G3-TEK-03', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G3-TEK-04', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G3-TEK-05', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G3-TEK-06', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G3-TEK-07', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G3-TEK-08', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G3-TEK-09', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'G3-TEK-10', '2023-09-04', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI', 'G3-SAGH-01', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI', 'G3-SAGH-02', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI', 'G3-SAGH-03', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI', 'G3-SAGH-04', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI', 'G3-SAGH-05', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI', 'G3-SAGH-06', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI', 'G3-SAGH-07', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI', 'G3-SAGH-08', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI', 'G3-SAGH-09', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI', 'G3-SAGH-10', '2021-10-05', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Inprimagailua', 'HP', 'LaserJet Pro M404dn', 'Laser zuri-beltza, sarea eta duplex', 'G3-INP-01', '2022-04-11', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Inprimagailua', 'HP', 'LaserJet Pro M404dn', 'Laser zuri-beltza, sarea eta duplex', 'G3-INP-02', '2022-04-11', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Eskanerra', 'Epson', 'Perfection V39', 'A4 ohe-eskanerra, USB', 'G3-ESK-01', '2022-04-11', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Eskanerra', 'Epson', 'Perfection V39', 'A4 ohe-eskanerra, USB', 'G3-ESK-02', '2022-04-11', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G3-AUR-01', '2022-03-14', 'Operatiboa'),
  ('Gela 3', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G3-AUR-02', '2022-03-14', 'Operatiboa'),
  ('Gela 3', 'Beste batzuk', 'Proiektorea', 'Epson', 'EB-X49', 'XGA, 3600 lumen, HDMI', 'G3-PRO-01', '2021-09-20', 'Operatiboa'),
  ('Gela 3', 'Beste batzuk', 'Switch-a', 'TP-Link', 'TL-SG1024', '24 ataka Gigabit, kudeaketarik gabea', 'G3-SWT-01', '2022-02-07', 'Operatiboa'),
  ('Gela 3', 'Beste batzuk', 'Wi-Fi sarbide-puntua', 'Ubiquiti', 'UniFi U6 Lite', 'Wi-Fi 6, PoE', 'G3-AP-01', '2023-03-08', 'Operatiboa'),
  ('Gela 3', 'Beste batzuk', 'SAI', 'APC', 'Back-UPS BX700U', '700 VA, 4 irteera, USB', 'G3-SAI-01', '2022-02-07', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD', 'G4-NUC-01', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD', 'G4-NUC-02', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD', 'G4-NUC-03', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD', 'G4-NUC-04', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD', 'G4-NUC-05', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD', 'G4-NUC-06', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD', 'G4-NUC-07', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD', 'G4-NUC-08', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD', 'G4-NUC-09', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD', 'G4-NUC-10', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD', 'G4-NUC-11', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD', 'G4-NUC-12', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G4-MONH-01', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G4-MONH-02', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G4-MONH-03', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G4-MONH-04', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G4-MONH-05', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G4-MONH-06', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G4-MONH-07', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G4-MONH-08', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G4-MONH-09', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G4-MONH-10', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G4-MONH-11', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina', 'G4-MONH-12', '2023-02-20', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G4-KIT-01', '2022-09-12', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G4-KIT-02', '2022-09-12', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G4-KIT-03', '2022-09-12', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G4-KIT-04', '2022-09-12', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G4-KIT-05', '2022-09-12', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G4-KIT-06', '2022-09-12', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G4-KIT-07', '2022-09-12', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G4-KIT-08', '2022-09-12', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G4-KIT-09', '2022-09-12', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G4-KIT-10', '2022-09-12', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G4-KIT-11', '2022-09-12', 'Operatiboa'),
  ('Gela 4', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G4-KIT-12', '2022-09-12', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Zerbitzaria', 'Dell', 'PowerEdge T150', 'Xeon E-2314, 32 GB RAM, 2 x 1 TB disko gogorra', 'G4-SRVD-01', '2023-03-08', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Zerbitzaria', 'Dell', 'PowerEdge T150', 'Xeon E-2314, 32 GB RAM, 2 x 1 TB disko gogorra', 'G4-SRVD-02', '2023-03-08', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Zerbitzaria', 'HPE', 'ProLiant ML30 Gen10 Plus', 'Xeon E-2314, 16 GB RAM, RAID 1', 'G4-SRVH-01', '2022-11-14', 'Operatiboa'),
  ('Gela 4', 'Mahaigaineko ekipoa', 'Zerbitzaria', 'HPE', 'ProLiant ML30 Gen10 Plus', 'Xeon E-2314, 16 GB RAM, RAID 1', 'G4-SRVH-02', '2022-11-14', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Switch-a', 'Cisco', 'CBS250-24T-4G', '24 ataka Gigabit, kudeagarria', 'G4-SWC-01', '2023-03-08', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Switch-a', 'Cisco', 'CBS250-24T-4G', '24 ataka Gigabit, kudeagarria', 'G4-SWC-02', '2023-03-08', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Switch-a', 'Cisco', 'CBS250-24T-4G', '24 ataka Gigabit, kudeagarria', 'G4-SWC-03', '2023-03-08', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Switch-a', 'Cisco', 'CBS250-24T-4G', '24 ataka Gigabit, kudeagarria', 'G4-SWC-04', '2023-03-08', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Switch-a', 'TP-Link', 'TL-SG1024', '24 ataka Gigabit, kudeaketarik gabea', 'G4-SWT-01', '2022-02-07', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Switch-a', 'TP-Link', 'TL-SG1024', '24 ataka Gigabit, kudeaketarik gabea', 'G4-SWT-02', '2022-02-07', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Routerra', 'MikroTik', 'hEX RB750Gr3', '5 ataka Gigabit, RouterOS', 'G4-RTR-01', '2023-03-08', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Routerra', 'MikroTik', 'hEX RB750Gr3', '5 ataka Gigabit, RouterOS', 'G4-RTR-02', '2023-03-08', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Routerra', 'MikroTik', 'hEX RB750Gr3', '5 ataka Gigabit, RouterOS', 'G4-RTR-03', '2023-03-08', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Routerra', 'MikroTik', 'hEX RB750Gr3', '5 ataka Gigabit, RouterOS', 'G4-RTR-04', '2023-03-08', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Wi-Fi sarbide-puntua', 'Ubiquiti', 'UniFi U6 Lite', 'Wi-Fi 6, PoE', 'G4-AP-01', '2023-03-08', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Wi-Fi sarbide-puntua', 'Ubiquiti', 'UniFi U6 Lite', 'Wi-Fi 6, PoE', 'G4-AP-02', '2023-03-08', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'SAI', 'APC', 'Back-UPS BX700U', '700 VA, 4 irteera, USB', 'G4-SAI-01', '2022-02-07', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'SAI', 'APC', 'Back-UPS BX700U', '700 VA, 4 irteera, USB', 'G4-SAI-02', '2022-02-07', 'Operatiboa'),
  ('Gela 4', 'Beste batzuk', 'Proiektorea', 'Epson', 'EB-X49', 'XGA, 3600 lumen, HDMI', 'G4-PRO-01', '2021-09-20', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'Lenovo', 'ThinkPad E14 Gen 4', 'Core i5, 16 GB RAM, 512 GB SSD, 14 hazbete', 'G5-LTLE-01', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'Lenovo', 'ThinkPad E14 Gen 4', 'Core i5, 16 GB RAM, 512 GB SSD, 14 hazbete', 'G5-LTLE-02', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'Lenovo', 'ThinkPad E14 Gen 4', 'Core i5, 16 GB RAM, 512 GB SSD, 14 hazbete', 'G5-LTLE-03', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'Lenovo', 'ThinkPad E14 Gen 4', 'Core i5, 16 GB RAM, 512 GB SSD, 14 hazbete', 'G5-LTLE-04', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'Lenovo', 'ThinkPad E14 Gen 4', 'Core i5, 16 GB RAM, 512 GB SSD, 14 hazbete', 'G5-LTLE-05', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'Lenovo', 'ThinkPad E14 Gen 4', 'Core i5, 16 GB RAM, 512 GB SSD, 14 hazbete', 'G5-LTLE-06', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'HP', 'ProBook 450 G9', 'Core i5, 16 GB RAM, 512 GB SSD, 15,6 hazbete', 'G5-LTHP-01', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'HP', 'ProBook 450 G9', 'Core i5, 16 GB RAM, 512 GB SSD, 15,6 hazbete', 'G5-LTHP-02', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'HP', 'ProBook 450 G9', 'Core i5, 16 GB RAM, 512 GB SSD, 15,6 hazbete', 'G5-LTHP-03', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'HP', 'ProBook 450 G9', 'Core i5, 16 GB RAM, 512 GB SSD, 15,6 hazbete', 'G5-LTHP-04', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'Dell', 'Latitude 5430', 'Core i7, 16 GB RAM, 512 GB SSD, 14 hazbete', 'G5-LTDE-01', '2023-04-17', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'Dell', 'Latitude 5430', 'Core i7, 16 GB RAM, 512 GB SSD, 14 hazbete', 'G5-LTDE-02', '2023-04-17', 'Operatiboa'),
  ('Gela 5', 'Portatila', 'Portatila', 'Dell', 'Latitude 5430', 'Core i7, 16 GB RAM, 512 GB SSD, 14 hazbete', 'G5-LTDE-03', '2023-04-17', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Dock estazioa', 'Dell', 'WD19S', 'USB-C dock estazioa, HDMI, DisplayPort eta Ethernet', 'G5-DOK-01', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Dock estazioa', 'Dell', 'WD19S', 'USB-C dock estazioa, HDMI, DisplayPort eta Ethernet', 'G5-DOK-02', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Dock estazioa', 'Dell', 'WD19S', 'USB-C dock estazioa, HDMI, DisplayPort eta Ethernet', 'G5-DOK-03', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Dock estazioa', 'Dell', 'WD19S', 'USB-C dock estazioa, HDMI, DisplayPort eta Ethernet', 'G5-DOK-04', '2023-10-02', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Pantaila', 'LG', '27UL500', '27 hazbete, 4K UHD, IPS', 'G5-MONL-01', '2022-06-27', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Pantaila', 'LG', '27UL500', '27 hazbete, 4K UHD, IPS', 'G5-MONL-02', '2022-06-27', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Pantaila', 'LG', '27UL500', '27 hazbete, 4K UHD, IPS', 'G5-MONL-03', '2022-06-27', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Pantaila', 'LG', '27UL500', '27 hazbete, 4K UHD, IPS', 'G5-MONL-04', '2022-06-27', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G5-KIT-01', '2022-09-12', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G5-KIT-02', '2022-09-12', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G5-KIT-03', '2022-09-12', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'G5-KIT-04', '2022-09-12', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Inprimagailua', 'HP', 'LaserJet Pro M404dn', 'Laser zuri-beltza, sarea eta duplex', 'G5-INP-01', '2022-04-11', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Eskanerra', 'Epson', 'Perfection V39', 'A4 ohe-eskanerra, USB', 'G5-ESK-01', '2022-04-11', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Bozgorailua', 'Jabra', 'Speak 510', 'Bilera-bozgorailua, USB eta Bluetooth', 'G5-BOZ-01', '2023-01-30', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Bozgorailua', 'Jabra', 'Speak 510', 'Bilera-bozgorailua, USB eta Bluetooth', 'G5-BOZ-02', '2023-01-30', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Web-kamera', 'Logitech', 'C920 HD Pro', 'Full HD 1080p, mikrofono estereoa', 'G5-CAM-01', '2022-03-14', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Web-kamera', 'Logitech', 'C920 HD Pro', 'Full HD 1080p, mikrofono estereoa', 'G5-CAM-02', '2022-03-14', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G5-AUR-01', '2022-03-14', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G5-AUR-02', '2022-03-14', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G5-AUR-03', '2022-03-14', 'Operatiboa'),
  ('Gela 5', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'G5-AUR-04', '2022-03-14', 'Operatiboa'),
  ('Mintegia', 'Mahaigaineko ekipoa', 'Lan-estazioa', 'Lenovo', 'ThinkStation P340', 'Core i7, 32 GB RAM, 1 TB SSD, Quadro T1000', 'MIN-WKS-01', '2022-06-27', 'Operatiboa'),
  ('Mintegia', 'Mahaigaineko ekipoa', 'Lan-estazioa', 'Lenovo', 'ThinkStation P340', 'Core i7, 32 GB RAM, 1 TB SSD, Quadro T1000', 'MIN-WKS-02', '2022-06-27', 'Operatiboa'),
  ('Mintegia', 'Mahaigaineko ekipoa', 'Lan-estazioa', 'Lenovo', 'ThinkStation P340', 'Core i7, 32 GB RAM, 1 TB SSD, Quadro T1000', 'MIN-WKS-03', '2022-06-27', 'Operatiboa'),
  ('Mintegia', 'Mahaigaineko ekipoa', 'Lan-estazioa', 'Lenovo', 'ThinkStation P340', 'Core i7, 32 GB RAM, 1 TB SSD, Quadro T1000', 'MIN-WKS-04', '2022-06-27', 'Operatiboa'),
  ('Mintegia', 'Portatila', 'Portatila', 'ASUS', 'VivoBook 15 X1500', 'Core i5, 8 GB RAM, 512 GB SSD, 15,6 hazbete', 'MIN-LTAS-01', '2022-09-19', 'Operatiboa'),
  ('Mintegia', 'Portatila', 'Portatila', 'ASUS', 'VivoBook 15 X1500', 'Core i5, 8 GB RAM, 512 GB SSD, 15,6 hazbete', 'MIN-LTAS-02', '2022-09-19', 'Operatiboa'),
  ('Mintegia', 'Portatila', 'Portatila', 'Acer', 'Aspire 5 A515-57', 'Core i5, 8 GB RAM, 512 GB SSD', 'MIN-LTAC-01', '2022-09-19', 'Operatiboa'),
  ('Mintegia', 'Portatila', 'Portatila', 'Acer', 'Aspire 5 A515-57', 'Core i5, 8 GB RAM, 512 GB SSD', 'MIN-LTAC-02', '2022-09-19', 'Operatiboa'),
  ('Mintegia', 'Portatila', 'Portatila', 'Apple', 'MacBook Air M2', 'Apple M2, 8 GB RAM, 256 GB SSD, 13,6 hazbete', 'MIN-LTMB-01', '2024-02-12', 'Operatiboa'),
  ('Mintegia', 'Portatila', 'Portatila', 'Apple', 'MacBook Air M2', 'Apple M2, 8 GB RAM, 256 GB SSD, 13,6 hazbete', 'MIN-LTMB-02', '2024-02-12', 'Operatiboa'),
  ('Mintegia', 'Portatila', 'Portatila', 'Microsoft', 'Surface Laptop 5', 'Core i5, 8 GB RAM, 256 GB SSD, ukimen-pantaila', 'MIN-LTMS-01', '2023-06-05', 'Operatiboa'),
  ('Mintegia', 'Portatila', 'Portatila', 'Microsoft', 'Surface Laptop 5', 'Core i5, 8 GB RAM, 256 GB SSD, ukimen-pantaila', 'MIN-LTMS-02', '2023-06-05', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Pantaila', 'LG', '27UL500', '27 hazbete, 4K UHD, IPS', 'MIN-MONL-01', '2022-06-27', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Pantaila', 'LG', '27UL500', '27 hazbete, 4K UHD, IPS', 'MIN-MONL-02', '2022-06-27', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Pantaila', 'LG', '27UL500', '27 hazbete, 4K UHD, IPS', 'MIN-MONL-03', '2022-06-27', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Pantaila', 'LG', '27UL500', '27 hazbete, 4K UHD, IPS', 'MIN-MONL-04', '2022-06-27', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'MIN-KIT-01', '2022-09-12', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'MIN-KIT-02', '2022-09-12', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'MIN-KIT-03', '2022-09-12', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea', 'MIN-KIT-04', '2022-09-12', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Kanpoko disko gogorra', 'Western Digital', 'My Passport 2TB', '2 TB, USB 3.0', 'MIN-HDD-01', '2022-12-01', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Kanpoko disko gogorra', 'Western Digital', 'My Passport 2TB', '2 TB, USB 3.0', 'MIN-HDD-02', '2022-12-01', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Kanpoko disko gogorra', 'Western Digital', 'My Passport 2TB', '2 TB, USB 3.0', 'MIN-HDD-03', '2022-12-01', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Kanpoko disko gogorra', 'Western Digital', 'My Passport 2TB', '2 TB, USB 3.0', 'MIN-HDD-04', '2022-12-01', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Plaka txikia', 'Raspberry Pi', 'Pi 4 Model B 8GB', 'Quad-core ARM, 8 GB RAM, Wi-Fi eta Bluetooth', 'MIN-RPI-01', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Plaka txikia', 'Raspberry Pi', 'Pi 4 Model B 8GB', 'Quad-core ARM, 8 GB RAM, Wi-Fi eta Bluetooth', 'MIN-RPI-02', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Plaka txikia', 'Raspberry Pi', 'Pi 4 Model B 8GB', 'Quad-core ARM, 8 GB RAM, Wi-Fi eta Bluetooth', 'MIN-RPI-03', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Plaka txikia', 'Raspberry Pi', 'Pi 4 Model B 8GB', 'Quad-core ARM, 8 GB RAM, Wi-Fi eta Bluetooth', 'MIN-RPI-04', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Plaka txikia', 'Raspberry Pi', 'Pi 4 Model B 8GB', 'Quad-core ARM, 8 GB RAM, Wi-Fi eta Bluetooth', 'MIN-RPI-05', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Plaka txikia', 'Raspberry Pi', 'Pi 4 Model B 8GB', 'Quad-core ARM, 8 GB RAM, Wi-Fi eta Bluetooth', 'MIN-RPI-06', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Mikrokontrolagailua', 'Arduino', 'UNO R3', 'ATmega328P, USB, kit hasierakoa', 'MIN-ARD-01', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Mikrokontrolagailua', 'Arduino', 'UNO R3', 'ATmega328P, USB, kit hasierakoa', 'MIN-ARD-02', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Mikrokontrolagailua', 'Arduino', 'UNO R3', 'ATmega328P, USB, kit hasierakoa', 'MIN-ARD-03', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Mikrokontrolagailua', 'Arduino', 'UNO R3', 'ATmega328P, USB, kit hasierakoa', 'MIN-ARD-04', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Mikrokontrolagailua', 'Arduino', 'UNO R3', 'ATmega328P, USB, kit hasierakoa', 'MIN-ARD-05', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Mikrokontrolagailua', 'Arduino', 'UNO R3', 'ATmega328P, USB, kit hasierakoa', 'MIN-ARD-06', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Mikrokontrolagailua', 'Arduino', 'UNO R3', 'ATmega328P, USB, kit hasierakoa', 'MIN-ARD-07', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Mikrokontrolagailua', 'Arduino', 'UNO R3', 'ATmega328P, USB, kit hasierakoa', 'MIN-ARD-08', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Mikrokontrolagailua', 'Arduino', 'UNO R3', 'ATmega328P, USB, kit hasierakoa', 'MIN-ARD-09', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Mikrokontrolagailua', 'Arduino', 'UNO R3', 'ATmega328P, USB, kit hasierakoa', 'MIN-ARD-10', '2023-11-06', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Pantaila interaktiboa', 'Promethean', 'ActivPanel 65', '65 hazbete, ukimen-pantaila, 4K', 'MIN-PIN-01', '2024-03-18', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Inprimagailua', 'HP', 'LaserJet Pro M404dn', 'Laser zuri-beltza, sarea eta duplex', 'MIN-INP-01', '2022-04-11', 'Operatiboa'),
  ('Mintegia', 'Periferikoak', 'Bozgorailua', 'Jabra', 'Speak 510', 'Bilera-bozgorailua, USB eta Bluetooth', 'MIN-BOZ-01', '2023-01-30', 'Operatiboa'),
  ('Mintegia', 'Beste batzuk', 'Switch-a', 'TP-Link', 'TL-SG1024', '24 ataka Gigabit, kudeaketarik gabea', 'MIN-SWT-01', '2022-02-07', 'Operatiboa'),
  ('Biltegia', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'BIL-PCHP-01', '2023-09-04', 'Operatiboa'),
  ('Biltegia', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'BIL-PCHP-02', '2023-09-04', 'Operatiboa'),
  ('Biltegia', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'BIL-PCLE-01', '2022-09-12', 'Operatiboa'),
  ('Biltegia', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD', 'BIL-PCLE-02', '2022-09-12', 'Operatiboa'),
  ('Biltegia', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD', 'BIL-PCDE-01', '2021-10-05', 'Operatiboa'),
  ('Biltegia', 'Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD', 'BIL-PCDE-02', '2021-10-05', 'Operatiboa'),
  ('Biltegia', 'Mahaigaineko ekipoa', 'Mini PC', 'ASUS', 'PN41', 'Celeron N5105, 8 GB RAM, 256 GB SSD', 'BIL-PN41-01', '2022-05-16', 'Operatiboa'),
  ('Biltegia', 'Mahaigaineko ekipoa', 'Mini PC', 'ASUS', 'PN41', 'Celeron N5105, 8 GB RAM, 256 GB SSD', 'BIL-PN41-02', '2022-05-16', 'Operatiboa'),
  ('Biltegia', 'Mahaigaineko ekipoa', 'Mini PC', 'ASUS', 'PN41', 'Celeron N5105, 8 GB RAM, 256 GB SSD', 'BIL-PN41-03', '2022-05-16', 'Operatiboa'),
  ('Biltegia', 'Mahaigaineko ekipoa', 'Mini PC', 'ASUS', 'PN41', 'Celeron N5105, 8 GB RAM, 256 GB SSD', 'BIL-PN41-04', '2022-05-16', 'Operatiboa'),
  ('Biltegia', 'Portatila', 'Portatila', 'Lenovo', 'ThinkPad E14 Gen 4', 'Core i5, 16 GB RAM, 512 GB SSD, 14 hazbete', 'BIL-LTLE-01', '2023-10-02', 'Operatiboa'),
  ('Biltegia', 'Portatila', 'Portatila', 'Lenovo', 'ThinkPad E14 Gen 4', 'Core i5, 16 GB RAM, 512 GB SSD, 14 hazbete', 'BIL-LTLE-02', '2023-10-02', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'BIL-MOND-01', '2023-09-04', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'BIL-MOND-02', '2023-09-04', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort', 'BIL-MOND-03', '2023-09-04', 'Konponketan'),
  ('Biltegia', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'BIL-TEK-01', '2023-09-04', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'BIL-TEK-02', '2023-09-04', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'BIL-TEK-03', '2023-09-04', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua', 'BIL-TEK-04', '2023-09-04', 'Konponketan'),
  ('Biltegia', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'BIL-SAG-01', '2023-09-04', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'BIL-SAG-02', '2023-09-04', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'BIL-SAG-03', '2023-09-04', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa', 'BIL-SAG-04', '2023-09-04', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI', 'BIL-SAGH-01', '2021-10-05', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI', 'BIL-SAGH-02', '2021-10-05', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'BIL-AUR-01', '2022-03-14', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm', 'BIL-AUR-02', '2022-03-14', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Kanpoko disko gogorra', 'Western Digital', 'My Passport 2TB', '2 TB, USB 3.0', 'BIL-HDD-01', '2022-12-01', 'Operatiboa'),
  ('Biltegia', 'Periferikoak', 'Kanpoko disko gogorra', 'Western Digital', 'My Passport 2TB', '2 TB, USB 3.0', 'BIL-HDD-02', '2022-12-01', 'Operatiboa'),
  ('Biltegia', 'Beste batzuk', 'Proiektorea', 'Epson', 'EB-X49', 'XGA, 3600 lumen, HDMI', 'BIL-PRO-01', '2021-09-20', 'Operatiboa'),
  ('Biltegia', 'Beste batzuk', 'Switch-a', 'TP-Link', 'TL-SG1024', '24 ataka Gigabit, kudeaketarik gabea', 'BIL-SWT-01', '2022-02-07', 'Operatiboa');

-- ---------------------------------------------------------------------
-- 4) CARGA  (no hace falta tocar nada de aqui para abajo)
-- ---------------------------------------------------------------------

-- 4.1 Catalogo: crea en "baliabideak" los objetos que aun no existan
INSERT INTO baliabideak (kategoriaId, izena, marka, modeloa, deskribapena)
SELECT k.id, t.izena, COALESCE(t.marka, ''), COALESCE(t.modeloa, ''), MAX(t.deskribapena)
FROM tmp_inbentarioa t
JOIN kategoriak k ON k.izena = t.kategoria
WHERE NOT EXISTS (
  SELECT 1 FROM baliabideak b
  WHERE b.kategoriaId = k.id
    AND b.izena = t.izena
    AND COALESCE(b.marka, '') = COALESCE(t.marka, '')
    AND COALESCE(b.modeloa, '') = COALESCE(t.modeloa, '')
)
GROUP BY k.id, t.izena, COALESCE(t.marka, ''), COALESCE(t.modeloa, '');

-- 4.2 Unidades: crea en "gailuak" cada unidad con su etiqueta
INSERT INTO gailuak (baliabideId, etiketa, erosketaData, egoera)
SELECT b.id, t.etiketa, t.erosketaData, COALESCE(t.egoera, 'Operatiboa')
FROM tmp_inbentarioa t
JOIN kategoriak k ON k.izena = t.kategoria
JOIN (
  SELECT MIN(id) AS id, kategoriaId, izena,
         COALESCE(marka, '') AS marka, COALESCE(modeloa, '') AS modeloa
  FROM baliabideak
  GROUP BY kategoriaId, izena, COALESCE(marka, ''), COALESCE(modeloa, '')
) b ON b.kategoriaId = k.id
   AND b.izena = t.izena
   AND b.marka = COALESCE(t.marka, '')
   AND b.modeloa = COALESCE(t.modeloa, '')
WHERE NOT EXISTS (SELECT 1 FROM gailuak g WHERE g.etiketa = t.etiketa);

-- 4.3 Asignacion: ubica cada unidad en su sala (solo si aun no esta en ninguna)
INSERT INTO mugimenduak (gelaId, gailuId, erabiltzaileId, hasieraData)
SELECT g.id, ga.id, @erabiltzaile_id, @hasiera_data
FROM tmp_inbentarioa t
JOIN gailuak ga ON ga.etiketa = t.etiketa
JOIN (SELECT MIN(id) AS id, izena FROM gelak GROUP BY izena) g ON g.izena = t.gela
WHERE NOT EXISTS (
  SELECT 1 FROM mugimenduak m WHERE m.gailuId = ga.id AND m.amaieraData IS NULL
);

-- ---------------------------------------------------------------------
-- 5) REVISION
-- ---------------------------------------------------------------------
-- 5.1 Filas que NO han quedado en su sala (debe salir vacio).
--     Si una unidad ya estaba en otra sala porque la moviste, aparece aqui: es normal.
SELECT t.etiketa, t.izena, t.gela AS gela_prevista,
  CASE
    WHEN k.id  IS NULL THEN 'La categoria no existe (revisa el nombre)'
    WHEN g.id  IS NULL THEN 'La sala no existe (revisa el nombre)'
    WHEN ga.id IS NULL THEN 'No se pudo crear la unidad'
    ELSE 'Esta en otra sala (no se ha movido)'
  END AS motivo
FROM tmp_inbentarioa t
LEFT JOIN kategoriak k  ON k.izena  = t.kategoria
LEFT JOIN gelak g       ON g.izena  = t.gela
LEFT JOIN gailuak ga    ON ga.etiketa = t.etiketa
LEFT JOIN mugimenduak m ON m.gailuId = ga.id AND m.amaieraData IS NULL AND m.gelaId = g.id
WHERE k.id IS NULL OR g.id IS NULL OR m.id IS NULL;

-- 5.2 Resumen: unidades que hay ahora mismo en cada sala
SELECT g.izena AS gela, g.taldea, COUNT(m.id) AS unitateak
FROM gelak g
LEFT JOIN mugimenduak m ON m.gelaId = g.id AND m.amaieraData IS NULL
GROUP BY g.id, g.izena, g.taldea
ORDER BY g.id;

DROP TEMPORARY TABLE IF EXISTS tmp_inbentarioa;
