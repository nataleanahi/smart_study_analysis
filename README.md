# Smart Study Research

Proyecto de análisis de datos orientado a identificar cómo distintos hábitos de estudio influyen en el rendimiento académico.

El proyecto recopila información mediante formularios, procesa los datos con Python y SQL, los almacena en MySQL, expone métricas mediante una API desarrollada con FastAPI y genera visualizaciones interactivas en Power BI.

---

## Objetivo

Investigar la relación entre variables como:

- Horas de sueño
- Nivel de ansiedad
- Momento del día de estudio
- Técnica de estudio utilizada
- Dificultad percibida del tema

y su impacto sobre:

- Comprensión del contenido
- Concentración durante la sesión

---

## Arquitectura del proyecto

Formulario Google Forms
↓
Archivos CSV
↓
ETL en Python (Pandas)
↓
MySQL
↓
FastAPI
↓
Power BI

---

## Tecnologías utilizadas

- Python
- Pandas
- MySQL
- SQL
- FastAPI
- Power BI
- Git
- GitHub

---

## Proceso ETL

El pipeline realiza:

- Lectura automática de múltiples archivos CSV.
- Normalización de respuestas.
- Conversión a modelo relacional.
- Generación de hashes únicos para evitar registros duplicados.
- Carga automática en MySQL.

---

## Análisis realizados

### Ansiedad y rendimiento

Se analiza cómo distintos niveles de ansiedad afectan la concentración y comprensión.

### Técnicas de estudio

Comparación del rendimiento promedio según la técnica utilizada.

### Sueño y rendimiento

Relación entre horas dormidas, ansiedad y comprensión.

### Momento del día

Impacto del horario de estudio sobre los resultados obtenidos.

### Dificultad percibida

Análisis de la relación entre dificultad, ansiedad y comprensión.

### Factores combinados

Estudio conjunto de horas de sueño y ansiedad para identificar patrones de rendimiento.

---

## Dashboard

El proyecto incluye un dashboard desarrollado en Power BI con métricas y visualizaciones interactivas.

Archivo:

dashboard/smart_study_analysis.pbix

---

## API

La API expone métricas agregadas mediante FastAPI.

Endpoints disponibles:

- /resumen
- /tecnicas
- /momento_del_dia
- /ansiedad_comprension
- /suenio_comprension
- /suenio_ansiedad
- /dificultad_ansiedad_comprension
- /factores_rendimiento

---
## Documentación de la API

FastAPI genera automáticamente documentación interactiva y detallada para todos los endpoints. Una vez que el servidor local esté corriendo, podés acceder desde tu navegador a cualquiera de estas dos interfaces:

- **Swagger UI (Interactiva):** `http://127.0.0.1:8000/docs` (Permite interactuar y probar las respuestas de los endpoints en vivo).
- **ReDoc (Estructurada):** `http://127.0.0.1:8000/redoc`

### Resumen de Endpoints Principales

| Endpoint | Método | Descripción | Ejemplo de Respuesta |
| :--- | :--- | :--- | :--- |
| `/resumen` | `GET` | Métmeras generales de la base de datos (Total de sesiones y promedios globales). | `{"total_sesiones": 61, "promedio_ansiedad": 3.05, ...}` |
| `/tecnicas` | `GET` | Comprensión promedio ordenada de mayor a menor según la técnica utilizada. | `[{"tecnica": "Ejercicios / práctica", "promedio_comprension": 3.8}]` |
| `/momento_del_dia` | `GET` | Rendimiento (ansiedad, concentración y comprensión) según la franja horaria. | `[{"cantidad_sesiones": 18, "momento_del_dia": "2. Mañana", ...}]` |
| `/ansiedad_comprension` | `GET` | Relación directa de impacto entre el nivel de ansiedad y las métricas de rendimiento. | `[{"nivel_ansiedad": 5, "promedio_comprension": 2.7}]` |

## Próximas mejoras

- Incorporar perfiles de estudiantes.
- Análisis por carrera.
- Predicción de rendimiento académico.
- Automatización de carga mediante Airbyte.
- Orquestación de pipelines con n8n.

---

## Autor

Anahí Natale
