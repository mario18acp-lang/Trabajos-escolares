#2.4.1 INSTALACIÓN Y GESTIÓN DE PAQUETERÍAS


#Instalación de los paquetes necesarios si aún no están instalados

#!pip install pandas
#!pip install psycopg2
#!pip install matplotlib


import pandas as pd
import psycopg2
import matplotlib.pyplot as plt


# Conexión a la base de datos PostgreSQL
conn = psycopg2.connect(
    dbname="MOVILIDAD",
    user="postgres",
    password="@NSYfJ6u",
    host="localhost"
)

# Función para ejecutar una consulta SQL y devolver un DataFrame
def consulta_sql(query, conn):
    return pd.read_sql(query, conn)

# Extraer todas las columnas de cada tabla y almacenarlas en un DataFrame
vivienda = consulta_sql('SELECT * FROM vivienda', conn)
transporte = consulta_sql('SELECT * FROM transporte', conn)
sociodemograficas = consulta_sql('SELECT * FROM sociodemograficas', conn)
hogar = consulta_sql('SELECT * FROM hogar', conn)
encuesta_viaje = consulta_sql('SELECT * FROM encuesta_viaje', conn)
cat_municipios = consulta_sql('SELECT * FROM cat_municipios', conn)
cat_estaciones = consulta_sql('SELECT * FROM cat_estaciones', conn)
cat_distritos = consulta_sql('SELECT * FROM cat_distritos', conn)

# Ejecución de una consulta SQL para obtener los comentarios de las columnas
query = """
SELECT 
    col_description(c.oid, cols.ordinal_position::int) AS column_comment
FROM 
    pg_catalog.pg_class c
    JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    JOIN information_schema.columns cols ON cols.table_name = c.relname AND cols.table_schema = n.nspname
WHERE 
    c.relname = 'vivienda' AND
    cols.column_name = 'p1_1' AND 
    c.relkind = 'r' AND 
    n.nspname = 'public'
"""

# Configura pandas para mostrar el comentario completo sin truncar
pd.set_option('display.max_colwidth', None)



comments = consulta_sql(query, conn)
print(comments)

##el promedio de personas por hogar (P1_1 de vivienda) 
##y el número promedio de autos (P2_1_1 de hogar) 
##para cada estrato sociodemográfico (ESTRATO de vivienda).

# Consulta SQL
query = """
  SELECT v.estrato, 
         AVG(v.p1_1) AS Promedio_Personas,
         AVG(h.p2_1_1) AS Promedio_Autos
  FROM vivienda v
  JOIN hogar h ON v.id_viv = h.id_viv
  GROUP BY v.estrato
  ORDER BY v.estrato;
"""

# Ejecutar la consulta y almacenar el resultado en un DataFrame
result = pd.read_sql(query, conn)

# Mostrar los resultados
print(result)

#Ejercicio 1: Análisis de la distribución de tipos de vivienda
#Objetivo: Investigar la distribución de los tipos de vivienda 
#en relación con el tamaño de la localidad y el estrato sociodemográfico.

#Descripción:
#Usando la tabla vivienda, realiza una consulta SQL para obtener la cantidad 
#de viviendas por tamaño de localidad (TLOC) y estrato sociodemográfico (ESTRATO).
#Analiza cómo el tamaño de la localidad afecta el estrato sociodemográfico 
#de las viviendas.

# Consulta SQL
query = """
SELECT tloc, estrato, COUNT(*) as total_viviendas
FROM vivienda
GROUP BY tloc, estrato
ORDER BY TLOC, estrato;
"""

# Ejecutar la consulta y almacenar el resultado en un DataFrame
result = pd.read_sql(query, conn)

# Mostrar los resultados
print(result)

#Ejercicio 2: Tendencias de movilidad en la base de datos encuesta_viaje
#Objetivo: Comprender las tendencias de movilidad en diferentes distritos.

#Descripción:
#Utiliza la tabla encuesta_viaje para analizar los patrones de viaje. 
#Combina esta tabla con cat_distritos para obtener descripciones legibles 
#de los distritos y calcula el número promedio de viajes realizados por distrito.


# Consulta SQL
query_viajes_distrito = """
SELECT cat_distritos.desc_dto AS Distrito, AVG(encuesta_viaje.n_via) AS Promedio_Viajes
FROM encuesta_viaje
JOIN cat_distritos ON encuesta_viaje.dto_origen = cat_distritos.distrito
GROUP BY cat_distritos.desc_dto
ORDER BY Promedio_Viajes DESC;
"""

# Ejecutar la consulta y almacenar el resultado en un DataFrame
viajes_distrito = pd.read_sql(query_viajes_distrito, conn)

# Mostrar los resultados
print(viajes_distrito)

#Ejercicio 3: Uso del transporte y su relación con las características 
#sociodemográficas
#Objetivo: Examinar la relación entre el uso de diferentes 
#tipos de transporte y las características sociodemográficas de los individuos.

#Descripción:
#Relaciona la tabla transporte con la tabla sociodemograficas para investigar 
#si hay alguna correlación entre el tipo de transporte utilizado (P5_14) 
#y el nivel de estudios (NIV) de los individuos. 
#Busca patrones en el uso de transporte público frente a privado entre diferentes 
#niveles de educación.

# Consulta SQL para relacionar transporte y características sociodemográficas
query_transporte_educacion = """
SELECT sociodemograficas.niv, transporte.p5_14, COUNT(*) as frecuencia
FROM transporte
JOIN encuesta_viaje ON transporte.id_via = encuesta_viaje.id_via
JOIN sociodemograficas ON encuesta_viaje.id_soc = sociodemograficas.id_soc
GROUP BY sociodemograficas.niv, transporte.p5_14
ORDER BY sociodemograficas.niv, transporte.p5_14;
"""

# Ejecutar la consulta y almacenar el resultado en un DataFrame
comments = pd.read_sql(query_transporte_educacion, conn)

# Mostrar los resultados
print(comments)

import seaborn as sns

# Asegurándonos de que las columnas están en el formato correcto
comments['niv'] = comments['niv'].astype('category')
comments['p5_14'] = comments['p5_14'].astype('category')
comments['frecuencia'] = pd.to_numeric(comments['frecuencia'])

# Crear la gráfica utilizando Seaborn para una visualización más sencilla y elegante
plt.figure(figsize=(10, 6))
sns.barplot(data=comments, x='niv', y='frecuencia', hue='p5_14', dodge=True)
plt.title("Relación entre Tipo de Transporte y Nivel de Estudios")
plt.xlabel("Nivel de Estudios")
plt.ylabel("Frecuencia de Uso")
plt.legend(title='Tipo de Transporte')
plt.show()


# Usar pandas para manipular datos (equivalente a dplyr en R)
vivienda_summary = vivienda.agg({'estrato': ['count', 'mean']})

# Preparar datos para visualización (equivalente a ggplot2 en R)
vivienda_data = vivienda.groupby('estrato').size().reset_index(name='num_viviendas')

# Visualizar los datos con matplotlib
plt.bar(vivienda_data['estrato'], vivienda_data['num_viviendas'])
plt.title('Número de Viviendas por Estrato Sociodemográfico')
plt.xlabel('Estrato Sociodemográfico')
plt.ylabel('Número de Viviendas')
plt.show()

#2.3.2. CREACIÓN Y MANIPULACIÓN DE MATRICES

#Crear un vector que contenga el número total de viviendas por estrato sociodemográfico.
#Convertir ese vector en una matriz de una sola columna.
#Nombrar la columna de la matriz como "Total_Viviendas".

# Crear un vector con el número total de viviendas por estrato

query_estrato = "SELECT estrato, COUNT(*) as total FROM vivienda GROUP BY estrato ORDER BY estrato"
vector_estrato = pd.read_sql(query_estrato, conn)['total']

# Convertir la Serie en una matriz de una sola columna
matrix_estrato = vector_estrato.values.reshape(-1, 1)

# Visualizar la matriz
plt.plot(matrix_estrato)
plt.title('Total de Viviendas por Estrato')
plt.xlabel('Estrato')
plt.ylabel('Total de Viviendas')
plt.show()

#Comprensión de Listas

# Crear una lista
datos_list = {
    'estratos': pd.read_sql("SELECT DISTINCT estrato FROM vivienda ORDER BY estrato", conn)['estrato'],
    'vivienda_df': pd.read_sql("SELECT * FROM vivienda LIMIT 10", conn),
    'hogar_df': pd.read_sql("SELECT * FROM hogar LIMIT 10", conn)
}

# Calcular la media del número de personas en vivienda (p1_1)
mean_personas_vivienda = datos_list['vivienda_df']['p1_1'].mean()

print(mean_personas_vivienda)

#Ejercicio 2.2.3.1: Función Personalizada para Calcular Estadísticas de Movilidad
#Objetivo: Escribir una función personalizada que calcule estadísticas básicas para una 
#columna específica de una tabla de la base de datos MOVILIDAD.

#Ejercicio:
#Escribe una función en R llamada calcular_estadisticas_movilidad que acepte el 
#nombre de una columna (como P1_1 de la tabla vivienda) y devuelva un data frame 
#con el promedio, la mediana y la desviación estándar para esa columna.

# Asumiendo que 'con' es una conexión activa y válida a la base de datos MOVILIDAD.
# Función para calcular estadísticas de una columna específica de la tabla vivienda.

def calcular_estadisticas_movilidad(nombre_columna):
    # Verificar que el nombre de la columna es un string y no está vacío
    if not isinstance(nombre_columna, str) or not nombre_columna:
        raise ValueError("Por favor, proporciona el nombre de una columna válida.")

    # Construir la consulta SQL
    query = f"SELECT {nombre_columna} FROM vivienda"

    # Intentar ejecutar la consulta y calcular las estadísticas
    try:
        data = pd.read_sql(query, conn)[nombre_columna]

        # Excluir valores NA para cálculos estadísticos
        data = data.dropna()

        # Calcular estadísticas
        estadisticas = {
            'Columna': nombre_columna,
            'Promedio': data.mean(),
            'Mediana': data.median(),
            'DesviacionEstandar': data.std()
        }

        return estadisticas

    except Exception as e:
        raise ValueError(f"Error al ejecutar la consulta SQL: {e}")

# Llamar a la función y mostrar resultados
print(calcular_estadisticas_movilidad("p1_3"))

#Ejercicio 2.2.3.1: Función Personalizada para Calcular Estadísticas de Movilidad
#Objetivo: Escribir una función personalizada que calcule estadísticas básicas para una 
#columna específica de una tabla de la base de datos MOVILIDAD.

#Ejercicio:
#Escribe una función en R llamada calcular_estadisticas_movilidad que acepte el nombre 
#de una columna (como P1_1 de la tabla vivienda) y devuelva un data frame con el promedio, 
#la mediana y la desviación estándar para esa columna.

def calcular_estadisticas(columna):
    # Construir la consulta SQL
    query = f"SELECT {columna} FROM hogar"
    
    # Ejecutar la consulta y obtener los datos
    try:
        data = pd.read_sql(query, conn)[columna]
        data = data.dropna()  # Eliminar valores NA
        # Calcular estadísticas
        return {
            'Mean': data.mean(),
            'Median': data.median(),
            'SD': data.std()
        }
    except Exception as e:
        raise ValueError(f"Error al ejecutar la consulta SQL: {e}")

# Lista de columnas de interés
columnas_interes = ["p2_1_1", "p2_1_2", "p2_1_3"]

# Diccionario para almacenar los resultados
resultados = {}

# Ciclo para calcular estadísticas para cada columna
for columna in columnas_interes:
    resultados[columna] = calcular_estadisticas(columna)

# Mostrar resultados
for columna, estadisticas in resultados.items():
    print(f"{columna}: {estadisticas}")

#Ejercicio 2.2.3.3: Aplicar Funciones Personalizadas a Data Frames
#Objetivo: Desarrollar la habilidad de aplicar funciones personalizadas 
#a data frames para analizar datos.

#Ejercicio:
#Utiliza la función apply() para calcular las estadísticas de movilidad 
#para todas las columnas numéricas de la tabla sociodemograficas.

# Supongamos que sociodemograficas es un DataFrame ya cargado con datos
# Filtrar sólo columnas numéricas
sociodemograficas_num = sociodemograficas.select_dtypes(include=['number'])

# Función para calcular estadísticas de una columna
def calcular_estadisticas_columna(x):
    x = x.dropna()  # Excluir valores NA
    return {
        'Media': x.mean(),
        'Mediana': x.median(),
        'DesviacionEstandar': x.std()
    }

# Aplicar la función a cada columna para calcular estadísticas
estadisticas_sociodemograficas = sociodemograficas_num.apply(calcular_estadisticas_columna)

# Mostrar los resultados
print(estadisticas_sociodemograficas)

#2.2.4 GRÁFICOS Y TABULADO DE DATOS 

#Distribución de Tipos de Vivienda por Tamaño de Localidad
#Supongamos que queremos visualizar cómo se distribuyen los tipos de vivienda 
#en función del tamaño de las localidades. Usaremos la tabla vivienda para este propósito.

# Realizar la consulta
query = "SELECT tloc, estrato, COUNT(*) as total FROM vivienda GROUP BY tloc, estrato"
vivienda = pd.read_sql(query, conn)

# Cambiar valores a numérico y eliminar nulos
vivienda['total'] = pd.to_numeric(vivienda['total'])
vivienda = vivienda.dropna(subset=['total'])

#!pip install seaborn
import seaborn as sns

# Configurando seaborn para una visualización más bonita
sns.set_theme(style="whitegrid")

# Crear el gráfico
plt.figure(figsize=(10, 6))
sns.barplot(x='tloc', y='total', hue='estrato', data=vivienda, dodge=True)
plt.title("Distribución de Viviendas por Tamaño de Localidad y Estrato")
plt.xlabel("Tamaño de Localidad")
plt.ylabel("Cantidad de Viviendas")
plt.show()

# Crear una tabla resumen
resumen = vivienda.groupby('tloc').agg(
    TotalViviendas=('total', 'sum'),
    PromedioPorEstrato=('total', 'mean')
)
print(resumen)

#Ejercicio 1: Distribución de Propósitos de Viaje
#Objetivo: Analizar la distribución de los propósitos de los viajes registrados en la tabla encuesta_viaje.

#Descripción:

#Realizar una consulta SQL para obtener la frecuencia de cada propósito de viaje (P5_13).
#Crear un gráfico de barras para visualizar la distribución de los propósitos de viaje.
#Generar una tabla resumen con la cantidad y el porcentaje de cada propósito.

# Obtener los datos de propósitos de viaje relevantes
query = """
SELECT p5_13, COUNT(*) as frecuencia 
FROM encuesta_viaje 
WHERE p5_13 BETWEEN 1 AND 10 OR p5_13 = 99 
GROUP BY p5_13
ORDER BY p5_13;
"""
proposito_viaje = pd.read_sql(query, conn)

# Convertir a numérico
proposito_viaje['p5_13'] = pd.to_numeric(proposito_viaje['p5_13'])
proposito_viaje['frecuencia'] = pd.to_numeric(proposito_viaje['frecuencia'])

# Mapear los códigos a descripciones
mapa_propositos = {
    1: 'Ir al hogar',
    2: 'Ir al trabajo',
    3: 'Ir a estudiar',
    4: 'Ir de compras',
    5: 'Convivir',
    6: 'Llevar o recoger',
    7: 'Hacer un trámite',
    8: 'Ir al médico',
    9: 'Ir a acto religioso',
    10: 'Otro',
    99: 'No sabe'
}
proposito_viaje['proposito'] = proposito_viaje['p5_13'].map(mapa_propositos)

# Crear un gráfico de barras
plt.figure(figsize=(10, 6))
plt.bar(proposito_viaje['proposito'], proposito_viaje['frecuencia'])
plt.title("Frecuencia de Propósitos de Viaje")
plt.xlabel("Propósito de Viaje")
plt.ylabel("Frecuencia")
plt.xticks(rotation=45)
plt.show()

# Calcular el total de viajes y los porcentajes
total_viajes = proposito_viaje['frecuencia'].sum()
proposito_viaje['porcentaje'] = (proposito_viaje['frecuencia'] / total_viajes) * 100

# Crear la tabla resumen
tabla_resumen = proposito_viaje[['proposito', 'frecuencia', 'porcentaje']]

# Mostrar la tabla resumen
print(tabla_resumen)

#Ejercicio 2: Análisis de Duración de Viajes
#Objetivo: Examinar la duración promedio de los viajes 
#por tipo de día (entre semana o sábado) en la tabla encuesta_viaje.


#1. Realizar una consulta SQL para obtener la duración 
#promedio de los viajes (P5_15_01 hasta P5_15_20) 
#por tipo de día (P5_3).

#2. Crear un gráfico de caja para visualizar la distribución 
#de la duración de los viajes por tipo de día.


#3. Generar una tabla resumen con el promedio, mediana y desviación estándar 
#de la duración de los viajes por tipo de día.

# Ejecutar la consulta SQL para la duración de viajes
query = """
SELECT P5_3, 
       AVG(
           COALESCE(P5_15_01, 0) + COALESCE(P5_15_02, 0) + COALESCE(P5_15_03, 0) + 
           COALESCE(P5_15_04, 0) + COALESCE(P5_15_05, 0) + COALESCE(P5_15_06, 0) + 
           COALESCE(P5_15_07, 0) + COALESCE(P5_15_08, 0) + COALESCE(P5_15_09, 0) + 
           COALESCE(P5_15_10, 0) + COALESCE(P5_15_11, 0) + COALESCE(P5_15_12, 0) + 
           COALESCE(P5_15_13, 0) + COALESCE(P5_15_14, 0) + COALESCE(P5_15_15, 0) + 
           COALESCE(P5_15_16, 0) + COALESCE(P5_15_17, 0) + COALESCE(P5_15_18, 0) + 
           COALESCE(P5_15_19, 0) + COALESCE(P5_15_20, 0)
       ) as duracion_promedio 
FROM encuesta_viaje 
GROUP BY P5_3
"""
duracion_viajes = pd.read_sql(query, conn)

# Crear un gráfico de caja
plt.figure(figsize=(10, 6))
sns.boxplot(x='p5_3', y='duracion_promedio', data=duracion_viajes)
plt.title("Duración de Viajes por Tipo de Día")
plt.xlabel("Tipo de Día")
plt.ylabel("Duración Promedio (minutos)")
plt.show()

# Ejecutar la consulta SQL para el total de viajes por medio de transporte
query = """
SELECT 
    SUM(CASE WHEN P5_14_01 = 1 THEN COALESCE(P5_15_01, 0) ELSE 0 END) as Total_Automovil,
    SUM(CASE WHEN P5_14_02 = 1 THEN COALESCE(P5_15_02, 0) ELSE 0 END) as Total_ColectivoMicro,
    SUM(CASE WHEN P5_14_03 = 1 THEN COALESCE(P5_15_03, 0) ELSE 0 END) as Total_TaxiApp,
    SUM(CASE WHEN P5_14_04 = 1 THEN COALESCE(P5_15_04, 0) ELSE 0 END) as Total_TaxiSitio,
    SUM(CASE WHEN P5_14_05 = 1 THEN COALESCE(P5_15_05, 0) ELSE 0 END) as Total_Metro,
    SUM(CASE WHEN P5_14_06 = 1 THEN COALESCE(P5_15_06, 0) ELSE 0 END) as Total_AutobusRTP_M1,
    SUM(CASE WHEN P5_14_07 = 1 THEN COALESCE(P5_15_07, 0) ELSE 0 END) as Total_Bicicleta,
    SUM(CASE WHEN P5_14_08 = 1 THEN COALESCE(P5_15_08, 0) ELSE 0 END) as Total_Autobus,
    SUM(CASE WHEN P5_14_09 = 1 THEN COALESCE(P5_15_09, 0) ELSE 0 END) as Total_Moto,
    SUM(CASE WHEN P5_14_10 = 1 THEN COALESCE(P5_15_10, 0) ELSE 0 END) as Total_Trolebus,
    SUM(CASE WHEN P5_14_11 = 1 THEN COALESCE(P5_15_11, 0) ELSE 0 END) as Total_Metrobus,
    SUM(CASE WHEN P5_14_12 = 1 THEN COALESCE(P5_15_12, 0) ELSE 0 END) as Total_TrenLigero,
    SUM(CASE WHEN P5_14_13 = 1 THEN COALESCE(P5_15_13, 0) ELSE 0 END) as Total_Suburbano,
    SUM(CASE WHEN P5_14_14 = 1 THEN COALESCE(P5_15_14, 0) ELSE 0 END) as Total_Caminar,
    SUM(CASE WHEN P5_14_15 = 1 THEN COALESCE(P5_15_15, 0) ELSE 0 END) as Total_Mexicable,
    SUM(CASE WHEN P5_14_16 = 1 THEN COALESCE(P5_15_16, 0) ELSE 0 END) as Total_Bicitaxi,
    SUM(CASE WHEN P5_14_17 = 1 THEN COALESCE(P5_15_17, 0) ELSE 0 END) as Total_Mototaxi,
    SUM(CASE WHEN P5_14_18 = 1 THEN COALESCE(P5_15_18, 0) ELSE 0 END) as Total_Escolar,
    SUM(CASE WHEN P5_14_19 = 1 THEN COALESCE(P5_15_19, 0) ELSE 0 END) as Total_Personal,
    SUM(CASE WHEN P5_14_20 = 1 THEN COALESCE(P5_15_20, 0) ELSE 0 END) as Total_Otro
FROM 
    encuesta_viaje;
"""
transporte_totals = pd.read_sql(query, conn)

# Crear un gráfico de barras para el total de viajes por medio de transporte
transporte_totals.plot(kind='bar')
plt.title("Total de Viajes por Medio de Transporte")
plt.xlabel("Medio de Transporte")
plt.ylabel("Total de Viajes")
plt.show()

# Cambiemos el tamaño del gráfico
plt.figure(figsize=(14, 8))

# Hacemos un gráfico de barras apiladas si es apropiado
transporte_totals.plot(kind='bar', stacked=True)

# Rotamos las etiquetas del eje x para mejor lectura
plt.xticks(rotation=45, ha='right')

# Movemos la leyenda fuera del gráfico para evitar superposiciones
plt.legend(loc='center left', bbox_to_anchor=(1.0, 0.5))

# Título y etiquetas de los ejes
plt.title('Total de Viajes por Medio de Transporte')
plt.xlabel('Medio de Transporte')
plt.ylabel('Total de Viajes')

# Ajustamos los límites del eje y si es necesario para mostrar todas las barras
plt.ylim(0, transporte_totals.max().max() + 10)

# Mostramos el gráfico
plt.tight_layout()  # Ajusta automáticamente los parámetros de la subtrama para que la subtrama se ajuste al área del gráfico
plt.show()