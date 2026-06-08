import pymysql
from sqlalchemy import create_engine
import pandas as pd
import os
import glob
import hashlib

conexion = pymysql.connect(
    host='localhost',
    user='root',
    password='',
    database='smart_study_db'
)

try:
    query = "SELECT * FROM hours_slept;"
    df_hours_slept = pd.read_sql(query, conexion)

    dict_hours_slept = df_hours_slept.set_index('hours_slept')['hours_slept_id'].to_dict()

    query = "SELECT * FROM course_type;"
    df_course_type = pd.read_sql(query, conexion)

    dict_course_type = df_course_type.set_index('course_type')['course_type_id'].to_dict()

    query = "SELECT * FROM break_type;"
    df_break_type = pd.read_sql(query, conexion)

    dict_break_type = df_break_type.set_index('break_type')['break_type_id'].to_dict()

    query = "SELECT * FROM duration_minutes;"
    df_duration_minutes = pd.read_sql(query, conexion)

    dict_duration_minutes = df_duration_minutes.set_index('range_in_minutes')['duration_minutes_id'].to_dict()

    query = "SELECT * FROM technique;"
    df_technique = pd.read_sql(query, conexion)

    dict_technique = df_technique.set_index('technique_type')['technique_id'].to_dict()

    query = "SELECT * FROM time_of_day;"
    df_time_of_day = pd.read_sql(query, conexion)

    dict_time_of_day = df_time_of_day.set_index('time_of_day')['time_of_day_id'].to_dict()


finally:
    conexion.close()

url_df = r"C:\Users\sistema\Desktop\smart_study_analysis\data\raw"

archivos  = glob.glob(
    os.path.join(url_df, "respuestas_formulario*.csv")
)

ruta_tabla_normalizacion = os.path.join(url_df, 'tabla_normalizacion.csv')

lista_dfs = []

for archivo in archivos:
    df = pd.read_csv(archivo)
    lista_dfs.append(df)

df_respuestas_formulario = pd.concat(
    lista_dfs,
    ignore_index=True
)

print(f"Archivos encontrados: {len(archivos)}")
print(f"Registros totales: {len(df_respuestas_formulario)}")

def generar_hash(fila):

    texto =(
        str(fila['Marca temporal']) +
        str(fila['¿Cuántas horas dormiste la noche anterior?']) +
        str(fila['Nivel de ansiedad antes de empezar a estudiar']) +
        str(fila['¿Qué tipo de materia estudiaste?']) +
        str(fila['Técnica principal de estudio'])
    )

    return hashlib.sha256(texto.encode()).hexdigest()

df_respuestas_formulario['record_hash'] = (
    df_respuestas_formulario.apply(
        generar_hash,
        axis=1
    )
)
print(
    df_respuestas_formulario[
        ['Marca temporal', 'record_hash']
    ].head()
)
pd.set_option('display.max_columns', None)

df_respuestas_formulario = (df_respuestas_formulario.rename
                            (columns={
                                    '¿Cuántas horas dormiste la noche anterior?': 'hours_slept_id',
                                    '¿Qué tipo de materia estudiaste?': 'course_type_id',
                                    'Técnica principal de estudio': 'technique_id',
                                    'Duración total de la sesión de estudio': 'duration_minutes_id',
                                    'Tipo principal de pausa': 'break_type_id',
                                    '¿En qué momento del día estudiaste?': 'time_of_day_id',
                                    '¿Tomaste pausas durante la sesión?': 'breaks'}))

df_respuestas_formulario = df_respuestas_formulario.drop(columns=[
    '¿Cómo estudiaste esta sesión?',
])

df_tabla_normalizacion = pd.read_csv(ruta_tabla_normalizacion)

dict_break_mapping = {
    'Sí, 1 pausa': 1,
    'Sí, 2 pausas': 2,
    'Sí, 3 o más': 3,
    'No': 0,

}

df_respuestas_formulario['breaks'] = (
        df_respuestas_formulario['breaks'].map(dict_break_mapping)
    )

dict_mapping = df_tabla_normalizacion.set_index('raw_value')['normalized_value'].to_dict()

columnas_a_normalizar = [
    'hours_slept_id',
    'course_type_id',
    'technique_id',
    'duration_minutes_id',
    'break_type_id',
    'time_of_day_id'
]

for columnas in columnas_a_normalizar:
    df_respuestas_formulario[columnas] = (
        df_respuestas_formulario[columnas].map(dict_mapping)
    )

dict_columnas = {
    'course_type_id': dict_course_type,
    'hours_slept_id': dict_hours_slept,
    'technique_id': dict_technique,
    'duration_minutes_id': dict_duration_minutes,
    'break_type_id': dict_break_type,
    'time_of_day_id': dict_time_of_day,
}

for columna, diccionario in dict_columnas.items():
    df_respuestas_formulario[columna] = (
        df_respuestas_formulario[columna]
        .map(diccionario)
        .astype('Int64')
    )

df_respuestas_formulario['time_of_day_id'] = df_respuestas_formulario['time_of_day_id'].fillna(5)

df_respuestas_formulario = df_respuestas_formulario.rename(
    columns={
        'Marca temporal': 'timestamp_form',
        'Nivel de ansiedad antes de empezar a estudiar': 'anxiety_level',
        'Dificultad percibida del tema': 'topic_difficulty',
        'Nivel de concentración durante la sesión': 'concentration_level',
        'Nivel de comprensión del tema': 'comprehension_level'
    }
)

df_respuestas_formulario['timestamp_form'] = pd.to_datetime(
    df_respuestas_formulario['timestamp_form'],
    dayfirst=True
)

print("----- NULOS -----")
print(df_respuestas_formulario.isnull().sum())

engine = create_engine('mysql+pymysql://root:@localhost/smart_study_db')

query = "SELECT record_hash FROM session"
df_hashes_db = pd.read_sql(query, engine)

hashes_db = set(df_hashes_db['record_hash'])

registros_antes = len(df_respuestas_formulario)

df_respuestas_formulario = (
    df_respuestas_formulario[
        ~df_respuestas_formulario['record_hash'].isin(hashes_db)
    ]
)

registros_despues = len(df_respuestas_formulario)

print("\n----- CONTROL DE DUPLICADOS DB -----")
print(f"Registros leídos de CSV: {registros_antes}")
print(f"Ya existentes en DB: {registros_antes - registros_despues}")
print(f"Nuevos a insertar: {registros_despues}")

try:
    if len(df_respuestas_formulario) == 0:
        print("\nNo hay registros nuevos para insertar.")
    else:
        df_respuestas_formulario.to_sql(
            name='session',
            con=engine,
            if_exists='append',
            index=False
        )

        print(
            f"\n¡Éxito! Se insertaron "
            f"{len(df_respuestas_formulario)} registros nuevos."
        )
except Exception as e:
    print("\n--- ERROR AL INSERTAR EN LA BASE DE DATOS ---")
    print(e)