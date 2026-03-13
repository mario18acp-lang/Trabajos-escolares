# 25/10/2025

#ACTIVIDADES DE SQL EN PHYTON

#INSTALACION PAQUETERIA

%pip install pandas
%pip install psycopg2
%pip install matplotlib

#IMPORTACION LIBRERIAS

import pandas as pd
import psycopg2
import matplotlib.pyplot as plt

#CONEXION A LA BASE DE DATOS POSTGRESQL

conn = psycopg2.connect(
    dbname="MOVILIDAD",
    user="postgres",
    password="Mario181295",
    host="Localhost"
    )

#FUNCION PARA CONBVERTIR EN DATAFRAME LOS DATOS DE SQL

def consulta_sql(query, conn):
    return pd.read_sql(query, conn)

#EXTRAER INFORMACION DE MUESTRA BASE DE DATOS

query = "SELECT * FROM vivienda"

vivienda = consulta_sql(query, conn)

query = "SELECT * FROM transporte"

transporte = consulta_sql(query, conn)

query = "SELECT * FROM sociodemograficas"

sociodemograficas = consulta_sql(query, conn)

query = "SELECT * FROM hogar"

hogar = consulta_sql(query, conn)

query = "SELECT * FROM encuesta_viaje"

encuesta_viaje = consulta_sql(query, conn)

query = "SELECT * FROM cat_municipios"

cat_municipios = consulta_sql(query, conn)

query = "SELECT * FROM cat_estaciones"

cat_estaciones = consulta_sql(query, conn)

query = "SELECT * FROM cat_distritos"

cat_distritos = consulta_sql(query, conn)

query = "SELECT * FROM vivienda WHERE p1_1 > 3"

viviendamayora3 = consulta_sql(query, conn)

viviendamayora4 = consulta_sql("SELECT * FROM vivienda WHERE p1_1 > 4", conn)

# EL PROMEDIO DE PERSONAS POR HOGAR (p1_1 de vivienda)
# EL PROMEDIO DE AUTOS (p2_1_1 de hogar)
# PARA CADA ESTRATO SOCIODEMOGRAFICO (estrato de vivienda)

query = "SELECT AVG(v.p1_1) AS promedio_personas, AVG(h.p2_1_1) AS promedio_autos, v.estrato AS estrato_sociodemografico FROM vivienda v JOIN hogar h ON v.id_viv = h.id_viv GROUP BY v.estrato ORDER BY v.estrato"

consulta1 = consulta_sql(query, conn)


#EJERCICIO 1
#USANDO LA TABLA VIVIENDA OBTEN LA CANTIDAD DE VIVIENDAS POR TAMAÑO DE LOCALIDAD (TLOC)
#Y ESTRATO SOCIODEMOGRAFICO (ESTRATO), ANALIZA COMO EL TAMAÑO DE LA LOCALIDAD
#AFECTA AL ESTRATO SOCIODEMOGRAFICO DE LAS VIVIENDAS

query= "SELECT tloc, estrato, COUNT(id_viv) FROM vivienda GROUP BY tloc,estrato"
analisis = consulta_sql(query, conn)



#EJERCICIO 2 TAREA
#Utiliza la tabla encuesta_viaje para analizar los patrones de viaje.
#Combina esta tabla con cat_distritos para obtener descripciones legibles
#de los distritos y calcula el número promedio de viajes realizados por distrito.
query= "SELECT MIN(n_via), MAX(n_via), AVG(n_via) FROM encuesta_viaje"
analisis2 = consulta_sql(query,conn)

query= '''SELECT cat_distritos.desc_dto AS Nombre_Distrito, AVG(encuesta_viaje.n_via) AS Promedio_Viajes 
FROM cat_distritos 
JOIN encuesta_viaje ON encuesta_viaje.dto_origen = cat_distritos.distrito 
GROUP BY cat_distritos.desc_dto ORDER BY Promedio_Viajes DESC;'''
analisis3 = consulta_sql(query, conn)


#EJERCICIO 3
query= '''SELECT t.p5_14 AS medio_transporte, s.niv AS nivel_estudios, COUNT (*) AS frecuencia
FROM transporte t
JOIN encuesta_viaje e ON t.id_via = e.id_via
JOIN sociodemograficas s ON e.id_soc =s.id_soc
GROUP BY nivel_estudios, medio_transporte
ORDER BY nivel_estudios, medio_transporte;'''


#EJERCICIO SQL
transporte = consulta_sql(query,conn)

mapa_estudios = {
    0: 'Ninguno',
    1: 'Preescolar',
    2: 'Primaria',
    3: 'Secundaria',
    4: 'Carrera técnica (post-secundaria)',
    5: 'Normal básica',
    6: 'Preparatoria o bachillerato',
    7: 'Carrera técnica (profesional)',
    8: 'Licenciatura',
    9: 'Maestría o Doctorado',
    99: 'No sabe'
    }

transporte['descripcion_nivel'] = transporte['nivel_estudios'].map(mapa_estudios)


mapa_transporte = { 
    1: 'Automóvil', 
    2: 'Colectivo/Micro', 
    3: 'Taxi (App internet)', 
    4: 'Taxi (sitio, calle u otro)', 
    5: 'Metro', 
    6: 'Autobús RTP o M1', 
    7: 'Bicicleta', 
    8: 'Autobús', 
    9: 'Moto', 
    10: 'Trolebús', 
    11: 'Metrobús o Mexibús', 
    12: 'Tren ligero', 
    13: 'Tren suburbano', 
    14: 'Caminar en la calle', 
    15: 'Mexicable', 
    16: 'Bicitaxi', 
    17: 'Mototaxi', 
    18: 'Transporte escolar', 
    19: 'Transporte de personal', 
    20: 'Otro' 
    }
transporte['descripcion_transporte'] = transporte['medio_transporte'].map(mapa_transporte)

import seaborn as sns
#Poner las columnas en el formato correcto

transporte['medio_transporte'] = transporte['medio_transporte'].astype('category')
transporte['nivel_estudios'] = transporte['nivel_estudios'].astype('category')
transporte['frecuencia'] = pd.to_numeric(transporte['frecuencia'])

plt.figure(figsize=(10,6))
sns.barplot(data=transporte, x='nivel_estudios', y='frecuencia', hue='medio_transporte', dodge=True)

plt.show()





#Crear un vector que contenga el numero total de viviendas en un estrato sociodemografico
#Convertir ese vector en una matriz en una sola columna
#Nombrar la columna de la matriz como "Total viviendas


query_estrato = "SELECT estrato, COUNT(*) AS total FROM vivienda GROUP BY estrato ORDER BY estrato"
vector_estrato = pd.read_sql(query_estrato,conn)['total']
matriz_estrato = vector_estrato.values.reshape(-1,1)
plt.plot(matriz_estrato)
plt.title('Total de viviendas por estrato')
plt.xlabel('Estrato')
plt.ylabel('Total de viviendas')
plt.show



query = '''SELECT e.p5_11a AS destino_viaje, s.niv AS nivel_estudios, COUNT (*) AS frecuencia
FROM encuesta_viaje e
JOIN sociodemograficas s ON e.id_soc =s.id_soc
GROUP BY nivel_estudios, destino_viaje
ORDER BY nivel_estudios, destino_viaje;'''

destino_viaje = consulta_sql(query,conn)

mapa_estudios = {
    0: 'Ninguno',
    1: 'Preescolar',
    2: 'Primaria',
    3: 'Secundaria',
    4: 'Carrera técnica (post-secundaria)',
    5: 'Normal básica',
    6: 'Preparatoria o bachillerato',
    7: 'Carrera técnica (profesional)',
    8: 'Licenciatura',
    9: 'Maestría o Doctorado',
    99: 'No sabe'
    }

destino_viaje['descripcion_nivel'] = destino_viaje['nivel_estudios'].map(mapa_estudios)

mapa_destino = { 
    1: 'Su hogar', 
    2: 'Escuela', 
    3: 'Oficina', 
    4: 'Fabrica o taller', 
    5: 'Comercio, mercado, tienda o centro comercial', 
    6: 'Centro cultural o area recreativa', 
    7: 'Otra vivienda', 
    8: 'Clinica, hospital,consultorio o laboratorio clinico', 
    9: 'Restaurante, bar, cafetería', 
    10: 'Deportivo o gimnasio', 
    11: 'Bases o estaciones de transporte publico', 
    12: 'Obra en construccion', 
    13: 'Otros servicios', 
    14: 'Recinto religioso', 
    15: 'Via publica', 
    16: 'Otro',  
    99: 'No sabe' 
    }

destino_viaje['descripcion_destino'] = destino_viaje['destino_viaje'].map(mapa_destino)

destino_viaje['destino_viaje'] = destino_viaje['destino_viaje'].astype('category')
destino_viaje['nivel_estudios'] = destino_viaje['nivel_estudios'].astype('category')
destino_viaje['frecuencia'] = pd.to_numeric(destino_viaje['frecuencia'])

plt.figure(figsize=(10,6))
sns.barplot(data=destino_viaje, x='nivel_estudios', y='frecuencia', hue='destino_viaje', dodge=True)

plt.show()