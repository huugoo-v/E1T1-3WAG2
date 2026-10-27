-- =====================================================================
--  CARGA DE INVENTARIO REAL Y ASIGNACION A SALAS
--  Proyecto E1T1-3WAG2  ·  base de datos: e1inbentarioa
--
--  Como usarlo (phpMyAdmin):
--    1. Rellena el bloque "2) TU LISTA" (descomentalo y pon tus filas).
--    2. Cambia en "1) AJUSTES" el usuario que figurara en los movimientos.
--    3. Pestaña SQL de phpMyAdmin -> pega todo el fichero -> Continuar.
--
--  Que hace, siguiendo el modelo del proyecto:
--    baliabideak  = catalogo (que es el objeto: nombre, marca, modelo, categoria)
--    gailuak      = cada unidad fisica, con su ETIQUETA unica de inventario
--    mugimenduak  = asigna una unidad a una sala (amaieraData NULL = esta ahi ahora)
--
--  Se puede ejecutar varias veces: lo que ya existe no se duplica.
--  Una unidad que YA esta asignada a una sala no se mueve (ver revision final).
-- =====================================================================

USE e1inbentarioa;

-- ---------------------------------------------------------------------
-- 1) AJUSTES
-- ---------------------------------------------------------------------
-- Usuario que quedara registrado como autor de las asignaciones.
-- Debe existir en la pagina "Erabiltzaileak" (cambia 'Joseba' si hace falta).
SET @erabiltzaile_id := (SELECT id FROM erabiltzaileak WHERE username = 'Joseba');
-- Fecha de inicio de las asignaciones (por defecto, hoy).
SET @hasiera_data := CURDATE();

-- Si el resultado de esta consulta sale NULL, el usuario no existe:
SELECT @erabiltzaile_id AS erabiltzaile_id_aukeratua;

-- Salas actuales (los nombres de tu lista deben coincidir EXACTAMENTE con estos):
SELECT id, izena, taldea FROM gelak ORDER BY id;
-- Categorias validas: Mahaigaineko ekipoa, Portatila, Periferikoak, Beste batzuk
SELECT id, izena FROM kategoriak ORDER BY id;

-- ---------------------------------------------------------------------
-- 2) TU LISTA  (una fila = UNA UNIDAD FISICA)
--
--   gela          -> nombre exacto de la sala (tabla gelak)
--   kategoria     -> nombre exacto de la categoria (tabla kategoriak)
--   izena         -> nombre del objeto
--   marka/modeloa -> pon '' si no tiene
--   deskribapena  -> texto libre, '' si no hay
--   etiketa       -> etiqueta de inventario, UNICA en toda la lista
--   erosketaData  -> 'AAAA-MM-DD' o NULL si no se sabe
--   egoera        -> 'Operatiboa' (valor por defecto del proyecto) u otro estado
--
--  Quita los /* */ de abajo y sustituye los ejemplos por tus datos reales.
--  Los ejemplos NO se cargan mientras sigan comentados.
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

/*
INSERT INTO tmp_inbentarioa
  (gela, kategoria, izena, marka, modeloa, deskribapena, etiketa, erosketaData, egoera)
VALUES
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PC-01', '2023-09-15', 'Operatiboa'),
  ('Gela 1', 'Mahaigaineko ekipoa', 'Ordenagailua', 'HP', 'ProDesk 400 G7', 'Core i5, 16 GB RAM, 512 GB SSD', 'G1-PC-02', '2023-09-15', 'Operatiboa'),
  ('Gela 1', 'Periferikoak',        'Pantaila',     'Dell', 'P2422H',        '24 pulgadas',                     'G1-MON-01', NULL,        'Operatiboa'),
  ('Mintegia', 'Portatila',         'Portatila',    'Lenovo', 'ThinkPad E14', '',                                'MIN-POR-01', '2024-01-10', 'Operatiboa');
*/

-- ---------------------------------------------------------------------
-- 3) CARGA  (no hace falta tocar nada de aqui para abajo)
-- ---------------------------------------------------------------------

-- 3.1 Catalogo: crea en "baliabideak" los objetos que aun no existen
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

-- 3.2 Unidades: crea en "gailuak" cada unidad con su etiqueta
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

-- 3.3 Asignacion: crea en "mugimenduak" la ubicacion actual de cada unidad
--     (solo si la unidad todavia no tiene ninguna sala activa)
INSERT INTO mugimenduak (gelaId, gailuId, erabiltzaileId, hasieraData)
SELECT g.id, ga.id, @erabiltzaile_id, @hasiera_data
FROM tmp_inbentarioa t
JOIN gailuak ga ON ga.etiketa = t.etiketa
JOIN (SELECT MIN(id) AS id, izena FROM gelak GROUP BY izena) g ON g.izena = t.gela
WHERE NOT EXISTS (
  SELECT 1 FROM mugimenduak m WHERE m.gailuId = ga.id AND m.amaieraData IS NULL
);

-- ---------------------------------------------------------------------
-- 4) REVISION
-- ---------------------------------------------------------------------
-- 4.1 Filas de tu lista que NO han quedado asignadas a la sala indicada.
--     Si sale vacio, todo ha ido bien. Si no, corrige la lista y vuelve a ejecutar.
SELECT t.etiketa, t.izena, t.gela, t.kategoria,
  CASE
    WHEN k.id  IS NULL THEN 'La categoria no existe (revisa el nombre)'
    WHEN g.id  IS NULL THEN 'La sala no existe (revisa el nombre)'
    WHEN ga.id IS NULL THEN 'No se pudo crear la unidad'
    ELSE 'Ya estaba asignada a otra sala (no se ha movido)'
  END AS problema
FROM tmp_inbentarioa t
LEFT JOIN kategoriak k  ON k.izena  = t.kategoria
LEFT JOIN gelak g       ON g.izena  = t.gela
LEFT JOIN gailuak ga    ON ga.etiketa = t.etiketa
LEFT JOIN mugimenduak m ON m.gailuId = ga.id AND m.amaieraData IS NULL AND m.gelaId = g.id
WHERE k.id IS NULL OR g.id IS NULL OR m.id IS NULL;

-- 4.2 Resumen: unidades que hay ahora mismo en cada sala
SELECT g.izena AS gela, COUNT(m.id) AS unitateak
FROM gelak g
LEFT JOIN mugimenduak m ON m.gelaId = g.id AND m.amaieraData IS NULL
GROUP BY g.id, g.izena
ORDER BY g.id;

DROP TEMPORARY TABLE IF EXISTS tmp_inbentarioa;
