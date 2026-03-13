#2.3.1 INSTALACIÓN Y GESTIÓN DE PAQUETERÍAS


# Opción 1. Instalación de los paquetes necesarios si aún no están instalados

if (!require("dplyr")) install.packages("dplyr")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("DBI")) install.packages("DBI")
if (!require("RPostgres")) install.packages("RPostgres")


# OPción 2. Instalar los paquetes en el entorno aislado del proyecto
#if (!require(renv)) {
#  install.packages("renv")}
#library(renv)
#renv::install("dplyr")
#renv::install("ggplot2")
#renv::install("DBI")
#renv::install("RPostgres")

# Después de instalar, registra el estado actual de los paquetes con renv
#renv::snapshot()

#Opción 3. Instalación de paquetería

packages <- c("dplyr", "ggplot2", "DBI", "RPostgres")
for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

# Cargar los paquetes necesarios

library(dplyr)
library(ggplot2)
library(DBI)
library(RPostgres)

#2.3.1.1 Consultas desde R de tablas mediante el lenguaje SQL. 


# Establecer la conexión a la base de datos
con <- dbConnect(RPostgres::Postgres(),
                 dbname = "MOVILIDAD",
                 host = "localhost", # o la IP si la base de datos está en un servidor remoto
                 port = 5432,
                 user = "postgres",
                 password = "@NSYfJ6u")

#EXTRAER TODAS LAS COLUMNAS

# Extraer los datos de la tabla vivienda y almacenarlos en un data frame
vivienda <- dbGetQuery(con, "SELECT * FROM vivienda")

# Extraer los datos de la tabla vivienda y almacenarlos en un data frame
transporte <- dbGetQuery(con, "SELECT * FROM transporte")

# Extraer los datos de la tabla vivienda y almacenarlos en un data frame
sociodemograficas <- dbGetQuery(con, "SELECT * FROM sociodemograficas")

# Extraer los datos de la tabla vivienda y almacenarlos en un data frame
hogar <- dbGetQuery(con, "SELECT * FROM hogar")

# Extraer los datos de la tabla vivienda y almacenarlos en un data frame
encuesta_viaje <- dbGetQuery(con, "SELECT * FROM encuesta_viaje")

# Extraer los datos de la tabla vivienda y almacenarlos en un data frame
cat_municipios <- dbGetQuery(con, "SELECT * FROM cat_municipios")

# Extraer los datos de la tabla vivienda y almacenarlos en un data frame
cat_estaciones <- dbGetQuery(con, "SELECT * FROM cat_estaciones")

# Extraer los datos de la tabla vivienda y almacenarlos en un data frame
cat_distritos <- dbGetQuery(con, "SELECT * FROM cat_distritos")


#Ejecución de una consulta SQL. 


query <- "
SELECT 
    col_description(c.oid, cols.ordinal_position::int) AS column_comment
FROM 
    pg_catalog.pg_class c
    JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    JOIN information_schema.columns cols ON cols.table_name = c.relname AND cols.table_schema = n.nspname
WHERE 
    c.relname = 'encuesta_viaje' AND
    cols.column_name = 'p5_13' AND 
    c.relkind = 'r' AND 
    n.nspname = 'public'
"


# Ejecutar la consulta
comments <- dbGetQuery(con, query)

# Mostrar los resultados
print(comments)

##el promedio de personas por hogar (P1_1 de vivienda) 
##y el número promedio de autos (P2_1_1 de hogar) 
##para cada estrato sociodemográfico (ESTRATO de vivienda).


query <- "
  SELECT v.ESTRATO, 
         AVG(v.p1_1) as Promedio_Personas,
         AVG(h.p2_1_1) as Promedio_Autos
  FROM vivienda v
  JOIN hogar h ON v.ID_VIV = h.ID_VIV
  GROUP BY v.ESTRATO
  ORDER BY v.ESTRATO;
"

# Ejecutar la consulta
result <- dbGetQuery(con, query)

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

query_tloc_estrato <- "
SELECT TLOC, ESTRATO, COUNT(*) as Total_Viviendas
FROM vivienda
GROUP BY TLOC, ESTRATO
ORDER BY TLOC, ESTRATO;
"
# Ejecutar la consulta
comments <- dbGetQuery(con, query_tloc_estrato)

# Mostrar los resultados
print(comments)

#Ejercicio 2: Tendencias de movilidad en la base de datos encuesta_viaje
#Objetivo: Comprender las tendencias de movilidad en diferentes distritos.

#Descripción:
#Utiliza la tabla encuesta_viaje para analizar los patrones de viaje. 
#Combina esta tabla con cat_distritos para obtener descripciones legibles 
#de los distritos y calcula el número promedio de viajes realizados por distrito.

query_viajes_distrito <- "
SELECT cat_distritos.Desc_Dto as Distrito, AVG(encuesta_viaje.N_VIA) as Promedio_Viajes
FROM encuesta_viaje
JOIN cat_distritos ON encuesta_viaje.DTO_ORIGEN = cat_distritos.Distrito
GROUP BY cat_distritos.Desc_Dto
ORDER BY Promedio_Viajes DESC;
"
# Ejecutar la consulta
comments <- dbGetQuery(con, query_viajes_distrito)

# Mostrar los resultados
print(comments)

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

query_transporte_educacion <- "
SELECT sociodemograficas.NIV, transporte.P5_14, COUNT(*) as Frecuencia
FROM transporte
JOIN encuesta_viaje ON transporte.ID_VIA = encuesta_viaje.ID_VIA
JOIN sociodemograficas ON encuesta_viaje.ID_SOC = sociodemograficas.ID_SOC
GROUP BY sociodemograficas.NIV, transporte.P5_14
ORDER BY sociodemograficas.NIV, transporte.P5_14;
"
# Ejecutar la consulta
comments <- dbGetQuery(con, query_transporte_educacion)

# Mostrar los resultados
print(comments)


# Usar dplyr para manipular datos
vivienda_summary <- dbGetQuery(con, "SELECT * FROM vivienda") %>%
  summarise(Count = n(), 
            Avg_Estrato = mean(estrato, na.rm = TRUE))

# Usar ggplot2 para visualizar datos

vivienda_data <- dbGetQuery(con, 
"SELECT ESTRATO, COUNT(*) as Num_Viviendas FROM vivienda GROUP BY ESTRATO")

# Convertir la columna 'estrato' a tipo integer si es necesario
vivienda_data$estrato <- as.integer(vivienda_data$estrato)

# Convertir la columna 'num_viviendas' a tipo numeric
vivienda_data$num_viviendas <- as.numeric(vivienda_data$num_viviendas)

# Crear el gráfico
ggplot(vivienda_data, aes(x = estrato, y = num_viviendas)) +
  geom_col() +
  labs(title = "Número de Viviendas por Estrato Sociodemográfico",
       x = "Estrato Sociodemográfico",
       y = "Número de Viviendas")


#2.3.2. CREACIÓN Y MANIPULACIÓN DE MATRICES

#Crear un vector que contenga el número total de viviendas por estrato sociodemográfico.
#Convertir ese vector en una matriz de una sola columna.
#Nombrar la columna de la matriz como "Total_Viviendas".

# Suponiendo que la conexión 'con' ya está establecida y que el paquete 'DBI' está cargado
library(DBI)

# Crear un vector con el número total de viviendas por estrato
vector_estrato <- dbGetQuery(con, "SELECT estrato, COUNT(*) as Total FROM vivienda GROUP BY estrato ORDER BY estrato")$total

# Convertir el vector en una matriz de una sola columna
matrix_estrato <- matrix(as.numeric(vector_estrato))

# Nombrar la columna de la matriz
colnames(matrix_estrato) <- "Total_Viviendas"

plot(matrix_estrato)

##Ejercicio 2.2.2.2: Comprensión de listas

# Crear una lista
datos_list <- list(
  estratos = dbGetQuery(con, "SELECT DISTINCT ESTRATO FROM vivienda ORDER BY ESTRATO")$ESTRATO,
  vivienda_df = dbGetQuery(con, "SELECT * FROM vivienda LIMIT 10"),
  hogar_df = dbGetQuery(con, "SELECT * FROM hogar LIMIT 10")
)

#2.2.3 FUNCIONES, CICLOS Y USO DE OTRAS ESTRUCTURAS DE DATOS. 

# Acceder y calcular la media del número de personas en vivienda (P1_1)
mean_personas_vivienda <- mean(datos_list$vivienda_df$p1_1, na.rm = TRUE)

#Ejercicio 2.2.3.1: Función Personalizada para Calcular Estadísticas de Movilidad
#Objetivo: Escribir una función personalizada que calcule estadísticas básicas para una 
#columna específica de una tabla de la base de datos MOVILIDAD.

#Ejercicio:
#Escribe una función en R llamada calcular_estadisticas_movilidad que acepte el 
#nombre de una columna (como P1_1 de la tabla vivienda) y devuelva un data frame 
#con el promedio, la mediana y la desviación estándar para esa columna.

# Asumiendo que 'con' es una conexión activa y válida a la base de datos MOVILIDAD.
# Función para calcular estadísticas de una columna específica de la tabla vivienda.

calcular_estadisticas_movilidad <- function(nombre_columna) {
  # Verificar que el nombre de la columna es un string y no está vacío
  if (!is.character(nombre_columna) || nombre_columna == "") {
    stop("Por favor, proporciona el nombre de una columna válida.")
  }
  
  # Construir la consulta SQL
  query <- sprintf("SELECT %s FROM vivienda", nombre_columna)
  
  # Intentar ejecutar la consulta y calcular las estadísticas
  tryCatch({
    data <- dbGetQuery(con, query)[[nombre_columna]]
    
    # Excluir valores NA para cálculos estadísticos
    data <- na.omit(data)
    
    # Calcular estadísticas
    estadisticas <- data.frame(
      Columna = nombre_columna,
      Promedio = mean(data),
      Mediana = median(data),
      DesviacionEstandar = sd(data)
    )
    
    return(estadisticas)
  }, error = function(e) {
    stop("Error al ejecutar la consulta SQL: ", e$message)
  })
}
# Llamar comando

vivienda$p1_3
print(calcular_estadisticas_movilidad("p1_3"))


#Ejercicio 2.2.3.1: Función Personalizada para Calcular Estadísticas de Movilidad
#Objetivo: Escribir una función personalizada que calcule estadísticas básicas para una 
#columna específica de una tabla de la base de datos MOVILIDAD.

#Ejercicio:
#Escribe una función en R llamada calcular_estadisticas_movilidad que acepte el nombre 
#de una columna (como P1_1 de la tabla vivienda) y devuelva un data frame con el promedio, 
#la mediana y la desviación estándar para esa columna.


# Lista de columnas de interés
columnas_interes <- c("P2_1_1", "P2_1_2", "P2_1_3")

# Función para calcular estadísticas
calcular_estadisticas <- function(columna) {
  query <- sprintf("SELECT %s FROM hogar", columna)
  data <- dbGetQuery(con, query)[[1]]
  data <- na.omit(data)
  c(Mean = mean(data), Median = median(data), SD = sd(data))
}

# Lista para almacenar los resultados
resultados <- list()

# Ciclo para calcular estadísticas para cada columna
for (columna in columnas_interes) {
  resultados[[columna]] <- calcular_estadisticas(columna)
}

# Mostrar resultados
print(resultados)


#Ejercicio 2.2.3.3: Aplicar Funciones Personalizadas a Data Frames
#Objetivo: Desarrollar la habilidad de aplicar funciones personalizadas 
#a data frames para analizar datos.

#Ejercicio:
#Utiliza la función apply() para calcular las estadísticas de movilidad 
#para todas las columnas numéricas de la tabla sociodemograficas.

# Supongamos que sociodemograficas es un data frame ya cargado con datos numéricos
# Primero, asegúrate de que sólo tienes columnas numéricas
sociodemograficas_num <- sociodemograficas[sapply(sociodemograficas, is.numeric)]

# Aplicar la función a cada columna para calcular estadísticas
estadisticas_sociodemograficas <- apply(sociodemograficas_num, 2, function(x) {
  # Excluir valores NA para cálculos estadísticos
  x <- na.omit(x)
  
  # Calcular estadísticas
  list(
    Media = mean(x),
    Mediana = median(x),
    DesviacionEstandar = sd(x)
  )
})

# Mostrar los resultados
print(estadisticas_sociodemograficas)

#2.2.4 GRÁFICOS Y TABULADO DE DATOS 

#Distribución de Tipos de Vivienda por Tamaño de Localidad
#Supongamos que queremos visualizar cómo se distribuyen los tipos de vivienda 
#en función del tamaño de las localidades. Usaremos la tabla vivienda para este propósito.

#Realizar la consulta.
vivienda <- dbGetQuery(con, "SELECT TLOC, ESTRATO, COUNT(*) as Total FROM vivienda GROUP BY TLOC, ESTRATO")
#Cambiar valores a numérico
vivienda$total <- as.numeric(vivienda$total)
#Eliminar nulos
vivienda <- vivienda %>% filter(!is.na(total))

ggplot(vivienda, aes(x = tloc, y = total, fill = estrato)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(title = "Distribución de Viviendas por Tamaño de Localidad y Estrato",
       x = "Tamaño de Localidad",
       y = "Cantidad de Viviendas") +
  theme_minimal()



#Creación de una Tabla resumen

resumen <- vivienda %>%
  group_by(tloc) %>%
  summarise(
    TotalViviendas = sum(total),
    PromedioPorEstrato = mean(total)
  )
print(resumen)



#Ejercicio 1: Distribución de Propósitos de Viaje
#Objetivo: Analizar la distribución de los propósitos de los viajes registrados en la tabla encuesta_viaje.

#Descripción:

#Realizar una consulta SQL para obtener la frecuencia de cada propósito de viaje (P5_13).
#Crear un gráfico de barras para visualizar la distribución de los propósitos de viaje.
#Generar una tabla resumen con la cantidad y el porcentaje de cada propósito.


# Obtener los datos de propósitos de viaje relevantes
query <- "
SELECT p5_13, COUNT(*) as frecuencia 
FROM encuesta_viaje 
WHERE p5_13 BETWEEN 1 AND 10 OR p5_13 = 99 
GROUP BY p5_13
ORDER BY p5_13;
"
proposito_viaje <- dbGetQuery(con, query)

#Convertimos a númerico el análisis
proposito_viaje$p5_13 <- as.numeric(proposito_viaje$p5_13)
proposito_viaje$frecuencia <- as.numeric(proposito_viaje$frecuencia)

# Crear un gráfico de barras
ggplot(proposito_viaje, aes(x = as.factor(p5_13), y = frecuencia, fill = as.factor(p5_13))) +
  geom_bar(stat = "identity") +
  scale_x_discrete(labels = c(
    '1' = 'Ir al hogar',
    '2' = 'Ir al trabajo',
    '3' = 'Ir a estudiar',
    '4' = 'Ir de compras',
    '5' = 'Convivir',
    '6' = 'Llevar o recoger',
    '7' = 'Hacer un trámite',
    '8' = 'Ir al médico',
    '9' = 'Ir a acto religioso',
    '10' = 'Otro',
    '99' = 'No sabe'
  )) +
  labs(title = "Frecuencia de Propósitos de Viaje",
       x = "Propósito de Viaje",
       y = "Frecuencia",
       fill = "Categoría") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Crear la tabla resumen
proposito_viaje$p5_13 <- factor(proposito_viaje$p5_13, levels = c('1','2','3','4','5','6','7','8','9','10','99'),
                                labels = c(
                                  'Ir al hogar',
                                  'Ir al trabajo',
                                  'Ir a estudiar',
                                  'Ir de compras',
                                  'Convivir',
                                  'Llevar o recoger',
                                  'Hacer un trámite',
                                  'Ir al médico',
                                  'Ir a acto religioso',
                                  'Otro',
                                  'No sabe'
                                ))

# Calcular el total de viajes y los porcentajes
total_viajes <- sum(proposito_viaje$frecuencia)
proposito_viaje <- proposito_viaje %>%
  mutate(porcentaje = (frecuencia / total_viajes) * 100)

# Crear la tabla resumen con descripciones y porcentajes
proposito_viaje <- proposito_viaje %>%
  select(proposito = p5_13, frecuencia, porcentaje)

# Imprimir la tabla resumen
print(proposito_viaje)

# Cerrar la conexión
dbDisconnect(con)

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

# Suponiendo que la conexión ya está establecida

# Obtener los datos
query <- "
SELECT P5_3, 
       AVG(
           COALESCE(P5_15_01, 0) + COALESCE(P5_15_02, 0) + COALESCE(P5_15_03, 0) + 
           COALESCE(P5_15_04, 0) + COALESCE(P5_15_05, 0) + COALESCE(P5_15_06, 0) + 
           COALESCE(P5_15_07, 0) + COALESCE(P5_15_08, 0) + COALESCE(P5_15_09, 0) + 
           COALESCE(P5_15_10, 0) + COALESCE(P5_15_11, 0) + COALESCE(P5_15_12, 0) + 
           COALESCE(P5_15_13, 0) + COALESCE(P5_15_14, 0) + COALESCE(P5_15_15, 0) + 
           COALESCE(P5_15_16, 0) + COALESCE(P5_15_17, 0) + COALESCE(P5_15_18, 0) + 
           COALESCE(P5_15_19, 0) + COALESCE(P5_15_20, 0)
       ) as Duracion_Promedio 
FROM encuesta_viaje 
GROUP BY P5_3
"
duracion_viajes <- dbGetQuery(con, query)



# Crear el gráfico de caja
ggplot(duracion_viajes, aes(x = as.factor(p5_3), y = duracion_promedio)) +
  geom_boxplot(fill = "green") +
  labs(title = "Duración de Viajes por Tipo de Día",
       x = "Tipo de Día",
       y = "Duración Promedio (minutos)")

# Crear la tabla resumen
resumen_duracion <- duracion_viajes %>%
  group_by(P5_3) %>%
  summarise(
    Promedio = mean(Duracion_Promedio, na.rm = TRUE),
    Mediana = median(Duracion_Promedio, na.rm = TRUE),
    DesviacionEstandar = sd(Duracion_Promedio, na.rm = TRUE)
  )

print(resumen_duracion)

# Cerrar la conexión
dbDisconnect(con)


query <- "
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
"

transporte_totals <- dbGetQuery(con, query)


transporte_totals <- sapply(transporte_totals, as.numeric)

# Crear una tabla resumen
tabla_resumen <- data.frame(
  MedioTransporte = names(transporte_totals),
  TotalViajes = unlist(transporte_totals)
)

# Ordenar la tabla por TotalViajes
tabla_resumen <- tabla_resumen[order(-tabla_resumen$TotalViajes),]

# Mostrar la tabla resumen
print(tabla_resumen)

# Crear un gráfico de barras
library(ggplot2)
ggplot(tabla_resumen, aes(x = MedioTransporte, y = TotalViajes)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Total de Viajes por Medio de Transporte",
       x = "Medio de Transporte",
       y = "Total de Viajes")

#GENEREMOS EN ANÁLISIS PROMEDIO

# Ejecutar la consulta modificada
transporte_totals <- dbGetQuery(con, query)

# Calcular el promedio para cada medio de transporte
transporte_promedios <- sapply(1:(ncol(transporte_totals)/2), function(i) {
  total_col <- transporte_totals[, (i * 2) - 1]
  cnt_col <- transporte_totals[, i * 2]
  return(total_col / cnt_col)
})

# Nombres de los medios de transporte
nombres_transportes <- names(transporte_totals)[seq(1, ncol(transporte_totals), 2)]

# Crear un data frame con los promedios
transporte_promedios_df <- data.frame(
  MedioTransporte = nombres_transportes,
  PromedioUso = transporte_promedios
)

# Mostrar los promedios
print(transporte_promedios_df)


# Gráfico de barras para visualizar el promedio de uso de cada medio de transporte
ggplot(transporte_promedios_df, aes(x = MedioTransporte, y = PromedioUso, fill =MedioTransporte)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Promedio de Uso de Diferentes Medios de Transporte",
       x = "Medio de Transporte",
       y = "Promedio de Uso",
       fill = "Medio de Transporte")


