-- SESIONES CON COMPRENSIÓN SUPERIOR AL PROMEDIO GENERAL
-- Analizando técnica y momento del día

WITH promedio_global_cte AS (
    SELECT AVG(comprehension_level) AS promedio_general
    FROM session
)

SELECT
    s.session_id,
    td.time_of_day AS momento_dia,
    t.technique_type AS tecnica,
    s.comprehension_level AS comprension_sesion,
    ROUND(p.promedio_general, 2) AS promedio_general_db,
    ROUND(
        s.comprehension_level - p.promedio_general,
        2
    ) AS diferencia_con_la_media
FROM session s
JOIN time_of_day td
    ON s.time_of_day_id = td.time_of_day_id
JOIN technique t
    ON s.technique_id = t.technique_id
CROSS JOIN promedio_global_cte p
WHERE s.comprehension_level > p.promedio_general
ORDER BY
    s.comprehension_level DESC,
    diferencia_con_la_media DESC;


-- SESIONES CON COMPRENSIÓN SUPERIOR AL PROMEDIO GENERAL
-- Analizando ansiedad

WITH promedio_global_cte AS (
    SELECT AVG(comprehension_level) AS promedio_general
    FROM session
)

SELECT
    s.session_id,
    s.anxiety_level AS nivel_ansiedad,
    s.comprehension_level AS comprension_sesion,
    ROUND(p.promedio_general, 2) AS promedio_general_db,
    ROUND(
        s.comprehension_level - p.promedio_general,
        2
    ) AS diferencia_con_la_media
FROM session s
CROSS JOIN promedio_global_cte p
WHERE s.comprehension_level > p.promedio_general
ORDER BY
    s.comprehension_level DESC,
    diferencia_con_la_media DESC;