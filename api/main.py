from fastapi import FastAPI
from sqlalchemy import create_engine, text

app = FastAPI()

engine = create_engine(
    "mysql+pymysql://root:@localhost/smart_study_db"
)


@app.get("/")
def inicio():
    """
    Verifica que la API esté funcionando.
    """
    return {"mensaje": "API Smart Study funcionando"}


@app.get("/resumen")
def resumen():
    """
    Métricas generales de la base de datos.
    """

    with engine.connect() as conexion:

        resultado_total = conexion.execute(
            text("""
                SELECT COUNT(*)
                FROM session
            """)
        )

        total_sesiones = resultado_total.scalar()

        resultado_promedios = conexion.execute(
            text("""
                SELECT
                    AVG(anxiety_level),
                    AVG(concentration_level),
                    AVG(comprehension_level)
                FROM session
            """)
        )

        fila = resultado_promedios.fetchone()

    return {
        "total_sesiones": total_sesiones,
        "promedio_ansiedad": round(fila[0], 2),
        "promedio_concentracion": round(fila[1], 2),
        "promedio_comprension": round(fila[2], 2)
    }


@app.get("/tecnicas")
def tecnicas():
    """
    Comprensión promedio según técnica de estudio.
    """

    with engine.connect() as conexion:

        resultado = conexion.execute(
            text("""
                SELECT
                    t.technique_type,
                    ROUND(AVG(s.comprehension_level), 2) AS promedio_comprension
                FROM session s
                JOIN technique t
                    ON s.technique_id = t.technique_id
                GROUP BY t.technique_type
                ORDER BY promedio_comprension DESC
            """)
        )

        filas = resultado.fetchall()

        respuesta = []

        for fila in filas:

            respuesta.append({
                "tecnica": fila[0],
                "promedio_comprension": float(fila[1])
            })

    return respuesta


@app.get("/momento_del_dia")
def momento_del_dia():
    """
    Rendimiento promedio según momento del día.
    """

    with engine.connect() as conexion:

        resultado = conexion.execute(
            text("""
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
                ORDER BY td.time_of_day_id ASC
            """)
        )

        filas = resultado.fetchall()

        respuesta = []

        for fila in filas:

            respuesta.append({
                "cantidad_sesiones": fila[0],
                "momento_del_dia": fila[1],
                "nivel_ansiedad": float(fila[2]),
                "promedio_concentracion": float(fila[3]),
                "promedio_comprension": float(fila[4])
            })

    return respuesta


@app.get("/ansiedad_comprension")
def ansiedad_comprension():
    """
    Relación entre ansiedad, concentración y comprensión.
    """

    with engine.connect() as conexion:

        resultado = conexion.execute(
            text("""
                SELECT
                    COUNT(*) AS total_sesiones,
                    anxiety_level AS nivel_ansiedad,
                    ROUND(AVG(concentration_level), 2) AS promedio_concentracion,
                    ROUND(AVG(comprehension_level), 2) AS promedio_comprension
                FROM session
                GROUP BY anxiety_level
                ORDER BY anxiety_level ASC
            """)
        )

        filas = resultado.fetchall()

        respuesta = []

        for fila in filas:

            respuesta.append({
                "total_sesiones": fila[0],
                "nivel_ansiedad": fila[1],
                "promedio_concentracion": float(fila[2]),
                "promedio_comprension": float(fila[3])
            })

    return respuesta


@app.get("/suenio_comprension")
def suenio_comprension():
    """
    Relación entre horas de sueño y comprensión.
    """

    with engine.connect() as conexion:

        resultado = conexion.execute(
            text("""
                SELECT
                    COUNT(s.session_id) AS cantidad_sesiones,
                    hs.hours_slept AS horas_dormidas,
                    ROUND(AVG(s.comprehension_level), 2) AS promedio_comprension
                FROM session s
                INNER JOIN hours_slept hs
                    ON hs.hours_slept_id = s.hours_slept_id
                GROUP BY hs.hours_slept
                ORDER BY hs.hours_slept_id ASC
            """)
        )

        filas = resultado.fetchall()

        respuesta = []

        for fila in filas:

            respuesta.append({
                "cantidad_sesiones": fila[0],
                "horas_dormidas": fila[1],
                "promedio_comprension": float(fila[2])
            })

    return respuesta


@app.get("/suenio_ansiedad")
def suenio_ansiedad():
    """
    Relación entre horas de sueño y ansiedad.
    """

    with engine.connect() as conexion:

        resultado = conexion.execute(
            text("""
                SELECT
                    COUNT(s.session_id) AS cantidad_sesiones,
                    hs.hours_slept AS horas_dormidas,
                    ROUND(AVG(s.anxiety_level), 2) AS promedio_ansiedad
                FROM session s
                INNER JOIN hours_slept hs
                    ON hs.hours_slept_id = s.hours_slept_id
                GROUP BY hs.hours_slept
                ORDER BY hs.hours_slept_id ASC
            """)
        )

        filas = resultado.fetchall()

        respuesta = []

        for fila in filas:

            respuesta.append({
                "cantidad_sesiones": fila[0],
                "horas_dormidas": fila[1],
                "promedio_ansiedad": float(fila[2])
            })

    return respuesta


@app.get("/dificultad_ansiedad_comprension")
def dificultad_ansiedad_comprension():
    """
    Impacto de la dificultad percibida sobre ansiedad y comprensión.
    """

    with engine.connect() as conexion:

        resultado = conexion.execute(
            text("""
                SELECT
                    COUNT(s.session_id) AS cantidad_sesiones,
                    s.topic_difficulty AS dificultad_percibida,
                    ROUND(AVG(s.anxiety_level), 2) AS promedio_ansiedad,
                    ROUND(AVG(s.comprehension_level), 2) AS promedio_comprension
                FROM session s
                GROUP BY s.topic_difficulty
                ORDER BY s.topic_difficulty ASC
            """)
        )

        filas = resultado.fetchall()

        respuesta = []

        for fila in filas:

            respuesta.append({
                "cantidad_sesiones": fila[0],
                "dificultad_percibida": fila[1],
                "promedio_ansiedad": float(fila[2]),
                "promedio_comprension": float(fila[3])
            })

    return respuesta


@app.get("/factores_rendimiento")
def factores_rendimiento():
    """
    Relación combinada entre sueño, ansiedad y comprensión.
    """

    with engine.connect() as conexion:

        resultado = conexion.execute(
            text("""
                SELECT
                    hs.hours_slept AS horas_dormidas,
                    s.anxiety_level AS nivel_ansiedad,
                    ROUND(AVG(s.comprehension_level), 2) AS promedio_comprension,
                    COUNT(*) AS total_sesiones
                FROM session s
                INNER JOIN hours_slept hs
                    ON hs.hours_slept_id = s.hours_slept_id
                GROUP BY hs.hours_slept, s.anxiety_level
                ORDER BY hs.hours_slept_id, s.anxiety_level
            """)
        )

        filas = resultado.fetchall()

        respuesta = []

        for fila in filas:

            respuesta.append({
                "horas_dormidas": fila[0],
                "nivel_ansiedad": fila[1],
                "promedio_comprension": float(fila[2]),
                "total_sesiones": fila[3]
            })

    return respuesta