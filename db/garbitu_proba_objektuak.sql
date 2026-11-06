-- =====================================================================
--  LIMPIEZA: QUITAR LOS OBJETOS DE PRUEBA DEL INVENTARIO
--  Proyecto E1T1-3WAG2  ·  base de datos: e1inbentarioa
--
--  El inventario lista las unidades que hay en las salas. Los objetos de
--  prueba (por ejemplo "awdwd", "adawd"...) estan en el catalogo pero no tienen
--  ninguna unidad en ninguna sala. Este script los borra.
--
--  Seguridad: SOLO borra objetos que no tienen ninguna unidad asignada.
--  Nunca toca unidades, salas ni movimientos.
--
--  Ejecutalo DESPUES de gelak_materiala_kargatu.sql (si no hay unidades en la
--  base de datos, no borra nada).
--
--  Como usarlo (phpMyAdmin): pestaña SQL -> pegar todo -> Continuar.
-- =====================================================================

USE e1inbentarioa;

-- 1) Vista previa: lo que se va a borrar
SELECT b.id, k.izena AS kategoria, b.izena, b.marka, b.modeloa
FROM baliabideak b
JOIN kategoriak k ON k.id = b.kategoriaId
WHERE NOT EXISTS (SELECT 1 FROM gailuak g WHERE g.baliabideId = b.id)
ORDER BY b.id;

-- 2) Borrado (solo si existen unidades en la base de datos)
DELETE FROM baliabideak
WHERE NOT EXISTS (SELECT 1 FROM gailuak g WHERE g.baliabideId = baliabideak.id)
  AND (SELECT COUNT(*) FROM gailuak) > 0;

-- 3) Comprobacion: objetos que quedan y unidades en cada sala
SELECT COUNT(*) AS objektuak_geratzen_dira FROM baliabideak;
SELECT g.izena AS gela, COUNT(m.id) AS unitateak
FROM gelak g
LEFT JOIN mugimenduak m ON m.gelaId = g.id AND m.amaieraData IS NULL
GROUP BY g.id, g.izena
ORDER BY g.id;
