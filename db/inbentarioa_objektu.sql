-- =====================================================================
--  CARGA DE 40 OBJETOS DE EJEMPLO EN EL INVENTARIO
--  Proyecto E1T1-3WAG2  ·  base de datos: e1inbentarioa
--
--  Llena la pantalla "Inbentarioa" (tabla baliabideak) con 40 objetos
--  repartidos en las 4 categorias de tu base de datos:
--    Mahaigaineko ekipoa (9) · Portatila (7) · Periferikoak (15) · Beste batzuk (9)
--
--  Como usarlo: phpMyAdmin -> pestaña SQL -> pegar todo -> Continuar.
--
--  Se puede ejecutar varias veces: si un objeto ya existe (misma categoria,
--  nombre, marca y modelo) no se vuelve a crear.
--  Las categorias se buscan por NOMBRE, asi que no depende de los ids.
-- =====================================================================

USE e1inbentarioa;

DROP TEMPORARY TABLE IF EXISTS tmp_baliabideak;
CREATE TEMPORARY TABLE tmp_baliabideak (
  kategoria    varchar(100) NOT NULL,
  izena        varchar(150) NOT NULL,
  marka        varchar(100) NOT NULL DEFAULT '',
  modeloa      varchar(100) NOT NULL DEFAULT '',
  deskribapena text         DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

INSERT INTO tmp_baliabideak (kategoria, izena, marka, modeloa, deskribapena) VALUES
  ('Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD'),
  ('Mahaigaineko ekipoa', 'Ordenagailua', 'Lenovo', 'ThinkCentre M70s', 'Core i5, 8 GB RAM, 256 GB SSD'),
  ('Mahaigaineko ekipoa', 'Ordenagailua', 'Dell', 'OptiPlex 3080', 'Core i3, 8 GB RAM, 256 GB SSD'),
  ('Mahaigaineko ekipoa', 'Mini PC', 'Intel', 'NUC 11 Pro', 'Core i5, 16 GB RAM, 512 GB SSD'),
  ('Mahaigaineko ekipoa', 'Mini PC', 'ASUS', 'PN41', 'Celeron N5105, 8 GB RAM, 256 GB SSD'),
  ('Mahaigaineko ekipoa', 'Dena batean ordenagailua', 'HP', 'ProOne 440 G9', '23,8 hazbeteko pantaila, Core i5, 16 GB RAM'),
  ('Mahaigaineko ekipoa', 'Zerbitzaria', 'Dell', 'PowerEdge T150', 'Xeon E-2314, 32 GB RAM, 2 x 1 TB disko gogorra'),
  ('Mahaigaineko ekipoa', 'Zerbitzaria', 'HPE', 'ProLiant ML30 Gen10 Plus', 'Xeon E-2314, 16 GB RAM, RAID 1'),
  ('Mahaigaineko ekipoa', 'Lan-estazioa', 'Lenovo', 'ThinkStation P340', 'Core i7, 32 GB RAM, 1 TB SSD, Quadro T1000'),
  ('Portatila', 'Portatila', 'Lenovo', 'ThinkPad E14 Gen 4', 'Core i5, 16 GB RAM, 512 GB SSD, 14 hazbete'),
  ('Portatila', 'Portatila', 'HP', 'ProBook 450 G9', 'Core i5, 16 GB RAM, 512 GB SSD, 15,6 hazbete'),
  ('Portatila', 'Portatila', 'Dell', 'Latitude 5430', 'Core i7, 16 GB RAM, 512 GB SSD, 14 hazbete'),
  ('Portatila', 'Portatila', 'ASUS', 'VivoBook 15 X1500', 'Core i5, 8 GB RAM, 512 GB SSD, 15,6 hazbete'),
  ('Portatila', 'Portatila', 'Acer', 'Aspire 5 A515-57', 'Core i5, 8 GB RAM, 512 GB SSD'),
  ('Portatila', 'Portatila', 'Apple', 'MacBook Air M2', 'Apple M2, 8 GB RAM, 256 GB SSD, 13,6 hazbete'),
  ('Portatila', 'Portatila', 'Microsoft', 'Surface Laptop 5', 'Core i5, 8 GB RAM, 256 GB SSD, ukimen-pantaila'),
  ('Periferikoak', 'Pantaila', 'Dell', 'P2422H', '24 hazbete, Full HD, HDMI eta DisplayPort'),
  ('Periferikoak', 'Pantaila', 'LG', '27UL500', '27 hazbete, 4K UHD, IPS'),
  ('Periferikoak', 'Pantaila', 'HP', 'E24 G5', '24 hazbete, Full HD, doitu daitekeen oina'),
  ('Periferikoak', 'Teklatua', 'Logitech', 'K120', 'USB teklatu kableduna, euskarazko diseinua'),
  ('Periferikoak', 'Teklatu eta sagu multzoa', 'Logitech', 'MK270', 'Haririk gabeko teklatua eta sagua, USB hartzailea'),
  ('Periferikoak', 'Sagua', 'Logitech', 'M90', 'USB sagu optikoa'),
  ('Periferikoak', 'Sagua', 'HP', '150', 'USB sagu kableduna, 1600 DPI'),
  ('Periferikoak', 'Web-kamera', 'Logitech', 'C920 HD Pro', 'Full HD 1080p, mikrofono estereoa'),
  ('Periferikoak', 'Aurikularrak', 'Logitech', 'H111', 'Estereo aurikularrak mikrofonoarekin, 3,5 mm'),
  ('Periferikoak', 'Bozgorailua', 'Jabra', 'Speak 510', 'Bilera-bozgorailua, USB eta Bluetooth'),
  ('Periferikoak', 'Inprimagailua', 'HP', 'LaserJet Pro M404dn', 'Laser zuri-beltza, sarea eta duplex'),
  ('Periferikoak', 'Eskanerra', 'Epson', 'Perfection V39', 'A4 ohe-eskanerra, USB'),
  ('Periferikoak', 'Dock estazioa', 'Dell', 'WD19S', 'USB-C dock estazioa, HDMI, DisplayPort eta Ethernet'),
  ('Periferikoak', 'Taula grafikoa', 'Wacom', 'Intuos S', 'Marrazteko taula, USB'),
  ('Periferikoak', 'Kanpoko disko gogorra', 'Western Digital', 'My Passport 2TB', '2 TB, USB 3.0'),
  ('Beste batzuk', 'Proiektorea', 'Epson', 'EB-X49', 'XGA, 3600 lumen, HDMI'),
  ('Beste batzuk', 'Switch-a', 'TP-Link', 'TL-SG1024', '24 ataka Gigabit, kudeaketarik gabea'),
  ('Beste batzuk', 'Switch-a', 'Cisco', 'CBS250-24T-4G', '24 ataka Gigabit, kudeagarria'),
  ('Beste batzuk', 'Routerra', 'MikroTik', 'hEX RB750Gr3', '5 ataka Gigabit, RouterOS'),
  ('Beste batzuk', 'Wi-Fi sarbide-puntua', 'Ubiquiti', 'UniFi U6 Lite', 'Wi-Fi 6, PoE'),
  ('Beste batzuk', 'SAI', 'APC', 'Back-UPS BX700U', '700 VA, 4 irteera, USB'),
  ('Beste batzuk', 'Pantaila interaktiboa', 'Promethean', 'ActivPanel 65', '65 hazbete, ukimen-pantaila, 4K'),
  ('Beste batzuk', 'Plaka txikia', 'Raspberry Pi', 'Pi 4 Model B 8GB', 'Quad-core ARM, 8 GB RAM, Wi-Fi eta Bluetooth'),
  ('Beste batzuk', 'Mikrokontrolagailua', 'Arduino', 'UNO R3', 'ATmega328P, USB, kit hasierakoa');

-- Crea solo los objetos que todavia no existen
INSERT INTO baliabideak (kategoriaId, izena, marka, modeloa, deskribapena)
SELECT k.id, t.izena, t.marka, t.modeloa, t.deskribapena
FROM tmp_baliabideak t
JOIN kategoriak k ON k.izena = t.kategoria
WHERE NOT EXISTS (
  SELECT 1 FROM baliabideak b
  WHERE b.kategoriaId = k.id
    AND b.izena = t.izena
    AND COALESCE(b.marka, '') = t.marka
    AND COALESCE(b.modeloa, '') = t.modeloa
);

-- Revision 1: filas cuya categoria no existe en tu base de datos (debe salir vacio)
SELECT t.kategoria, t.izena, t.marka, t.modeloa
FROM tmp_baliabideak t
LEFT JOIN kategoriak k ON k.izena = t.kategoria
WHERE k.id IS NULL;

-- Revision 2: objetos que hay ahora por categoria
SELECT k.izena AS kategoria, COUNT(b.id) AS objektuak
FROM kategoriak k
LEFT JOIN baliabideak b ON b.kategoriaId = k.id
GROUP BY k.id, k.izena
ORDER BY k.id;

DROP TEMPORARY TABLE IF EXISTS tmp_baliabideak;
