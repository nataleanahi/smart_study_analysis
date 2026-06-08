-- RESUMEN GENERAL

SELECT
    COUNT(*) AS total_sesiones,
    ROUND(AVG(anxiety_level), 2) AS promedio_ansiedad,
    ROUND(AVG(concentration_level), 2) AS promedio_concentracion,
    ROUND(AVG(comprehension_level), 2) AS promedio_comprension
FROM session;


-- RELACIÓN ANSIEDAD - COMPRENSIÓN

SELECT
    anxiety_level AS nivel_ansiedad,
    COUNT(*) AS total_sesiones,
    ROUND(AVG(concentration_level), 2) AS promedio_concentracion,
    ROUND(AVG(comprehension_level), 2) AS promedio_comprension
FROM session
GROUP BY anxiety_level
ORDER BY anxiety_level ASC;


-- TÉCNICAS DE ESTUDIO

SELECT
    COUNT(s.session_id) AS cantidad_sesiones,
    ROUND(AVG(comprehension_level), 2) AS promedio_comprension,
    t.technique_type AS tecnica_de_estudio
FROM session s
JOIN technique t
    ON t.technique_id = s.technique_id
GROUP BY t.technique_type
ORDER BY promedio_comprension DESC;


-- MOMENTO DEL DÍA

SELECT
    COUNT(s.session_id) AS cantidad_sesiones,
    td.time_of_day,
    ROUND(AVG(s.anxiety_level), 2) AS nivel_ansiedad,
    ROUND(AVG(s.concentration_level), 2) AS promedio_concentracion,
    ROUND(AVG(s.comprehension_level), 2) AS promedio_comprension
FROM session s
INNER JOIN time_of_day td
    ON td.time_of_day_id = s.time_of_day_id
GROUP BY td.time_of_day, td.time_of_day_id
HAVING td.time_of_day_id != 5
ORDER BY td.time_of_day_id ASC;


-- HORAS DORMIDAS Y COMPRENSIÓN

SELECT
    COUNT(s.session_id) AS cantidad_sesiones,
    hs.hours_slept AS horas_dormidas,
    ROUND(AVG(s.comprehension_level), 2) AS promedio_comprension
FROM session s
INNER JOIN hours_slept hs
    ON hs.hours_slept_id = s.hours_slept_id
GROUP BY hs.hours_slept, hs.hours_slept_id
ORDER BY hs.hours_slept_id ASC;


-- HORAS DORMIDAS Y ANSIEDAD

SELECT
    COUNT(s.session_id) AS cantidad_sesiones,
    hs.hours_slept AS horas_dormidas,
    ROUND(AVG(s.anxiety_level), 2) AS promedio_ansiedad
FROM session s
INNER JOIN hours_slept hs
    ON hs.hours_slept_id = s.hours_slept_id
GROUP BY hs.hours_slept, hs.hours_slept_id
ORDER BY hs.hours_slept_id ASC;


-- DIFICULTAD PERCIBIDA

SELECT
    COUNT(s.session_id) AS cantidad_sesiones,
    s.topic_difficulty AS dificultad_percibida,
    ROUND(AVG(s.anxiety_level), 2) AS promedio_ansiedad,
    ROUND(AVG(s.comprehension_level), 2) AS promedio_comprension
FROM session s
GROUP BY s.topic_difficulty
ORDER BY s.topic_difficulty ASC;


-- FACTORES DE RENDIMIENTO

SELECT
    hs.hours_slept,
    s.anxiety_level,
    ROUND(AVG(s.comprehension_level), 2) AS promedio_comprension,
    COUNT(*) AS total_sesiones
FROM session s
JOIN hours_slept hs
    ON hs.hours_slept_id = s.hours_slept_id
GROUP BY hs.hours_slept, s.anxiety_level
ORDER BY hs.hours_slept_id, s.anxiety_level;