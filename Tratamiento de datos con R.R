## Librerias ----
library("dplyr")
library("readr")
library("plyr")
library("fs") #para ubicar el directorio de los csv
library("lubridate") #bucle for
library("purrr") #fulljoin method
library("stringr") #environmentlist filter
library("readr") #exportar csv
library("openxlsx") #exportarxlsx
library("e1071") #estadisticos
library("tseries") #estadisticos


## Directorios de los archivos ----
setwd("/home/filibustero/Documentos/TFM/cryptocurrency-market-efficiency/csv070223") # TFM
#setwd("/home/filibustero/Documentos/R/Pruebas/Pruebas/tfm") # Muestra

## Lectura del directorio en busca de CSV ----
files <- dir(pattern = "*.csv")

## Crear un objeto por cada csv y una lista con todos los nombres ----
nombres <- list()
for(file in files){
  dummy <- as.character(gsub("\\.csv$", "", file))
  nombres <- append(nombres, dummy)
  ## Primero montar los dataframes
  dataframe <- read.csv(file, stringsAsFactors = FALSE)
  for(col in colnames(dataframe)){#checknombrecolumna
    ## Configurar el nombre del objeto a "df_file"
    dfnames2 <- as.character(gsub("\\.csv$", "", file))
    prefijo <- as.character("df_")
    dfnames_final <- paste(c(prefijo, dfnames2), collapse = "")
    assign(dfnames_final, dataframe)
 }
}

## Eliminar los dataframes residuales del bucle anterior del environment
  ## No es necesario hacerlo pero lo prefiero por orden
rm(col, dfnames_final, dfnames2, file, files, prefijo, dummy)

## Crear un objeto donde se almacenen los objetos creados en el loop anterior ----
objetosenvironment <- ls(pattern = "^df_")

## Obtener los nombres de las columnas de cada objeto ----
column_names <- sapply(mget(objetosenvironment), colnames)

## Longitud máxima del vector column_names ----
maxlong <- max(sapply(column_names, length))

## Rellenar los vectores con NA para igualar la longitud y que no de fallo el df----
filled_list <- lapply(column_names, function(vec) {
  c(vec, rep(NA, maxlong - length(vec)))
})

## Combinar los nuevos vectores rellenados con NA en un dataframe ----
csvycolumnas <- data.frame(filled_list)

## Exportar el objeto anterior para observar mejor los datos ----

if ("Nombresdecolumnas.xlsx" %in% dir()) {
  print(paste("No es necesario crear el XLSX, está en:", getwd()))
} else {
  write.xlsx(csvycolumnas, file = "Nombresdecolumnas.xlsx")
  print(paste("Se ha guardado el archivo en:", as.character(getwd()) ))
}

  ## Con un vistazo al XLSX se observa que casi todos los activos tienen una
  ## columna denominada ReferenceRate, ReferenceRateUSD y ReferenceRateEUR
  ## Buscar idoneidad
  ## Documentacion: https://docs.coinmetrics.io/info/metrics/ReferenceRate

## Comprobar si existen ciertas columnas es todos los activos ----
## Criterios de búsqueda
criterios <- c('PriceUSD', 'ReferenceRate', 'ReferenceRateUSD', 'ReferenceRateEUR')

## Crear un dataframe vacío para almacenar los resultados
columnacheck <- data.frame(matrix(ncol = length(criterios), nrow = length(column_names)))
colnames(columnacheck) <- criterios
rownames(columnacheck) <- names(column_names)

## Buscar en cada dataframe según los criterios de búsquedas
## En el primer for se itera a través de la secuencia de column_names
## El bucle se ejecuta 583 veces, una por activo
for (i in seq_along(column_names)) {
  ## Se guardan todos los nombres de la columna en una dataframe
  dataframetemporal <- column_names[[i]]
  ## Segundo for que se itera a través de la secuencia de búsqueda
  ## Se ejecuta 583*4 veces (nº de criterios)
  for (j in seq_along(criterios)) {
    colcriterios <- criterios[j]
    ## Comprueba si el criterio de la lista j está como valor en dataframetemporal
    ## Se almacena en la columna del activo i
    columnacheck[i, j] <- as.character(colcriterios %in% dataframetemporal)
    }
  }

## Comprobar longitudes de las columnas
## Guardar cada columna como valor lógico
columnachecklogicalpriceusd <- as.logical(columnacheck$PriceUSD)
columnachecklogicalRR <- as.logical(columnacheck$ReferenceRate)
columnachecklogicalRRUSD <- as.logical(columnacheck$ReferenceRateUSD)
columnachecklogicalRREUR <- as.logical(columnacheck$ReferenceRateEUR)
## Calcular la longitud de cada columnna
## Conseguir la frecuencia de valores TRUE
longPriceUSD <-  count(columnachecklogicalpriceusd)
longReferenceRate <- count(columnachecklogicalRR)
longReferenceRateUSD <- count(columnachecklogicalRRUSD)
longReferenceRateEUR <- count(columnachecklogicalRREUR)
## Guardar el valor TRUE en si mismo
longPriceUSD <- as.integer(longPriceUSD$freq[2])
longReferenceRate <- as.integer(longReferenceRate$freq[2])
longReferenceRateUSD <- as.integer(longReferenceRateUSD$freq[2])
longReferenceRateEUR <- as.integer(longReferenceRateEUR$freq[2])
## Crear una tabla
longitudescolumnas <- tibble("PriceUSD" = longPriceUSD,
                             "ReferenceRate" = longReferenceRate,
                             "ReferenceRateUSD" = longReferenceRateUSD,
                             "ReferenceRateEUR"= longReferenceRateEUR)
  ## En este caso, tanto RR como RRUSD tienen el mismo número de observaciones


## Montar el dataframe final con ReferenceRate o ReferenceRateUSD ----

## Borrar environment
rm(list = ls())

## Directorio de los archivos
setwd("/home/filibustero/Documentos/TFM/cryptocurrency-market-efficiency/csv070223") # TFM

## Lectura del directorio en busca de CSV
files <- dir(pattern = "*.csv")

## Bucle que crea objetos diferentes para cada CSV
nombres2 <- list()
for(file in files){
  dataframe <- read.csv(file, stringsAsFactors = FALSE)
  for(col in colnames(dataframe)){#checknombrecolumna
    if(col != "ReferenceRateUSD"){
    }
    else{
      ## Primero montar los dataframes y elegir solo dos columnas
      dataframe2 <- read.csv(file, stringsAsFactors = FALSE)
      dataframe2 <- dataframe2[c("time", "ReferenceRateUSD")]
      ## Configurar el nombre del objeto a "df_file"
      dfnames2 <- as.character(gsub("\\.csv$", "", file))
      nombres2 <- append(nombres2, dfnames2)
      prefijo <- as.character("df_")
      dfnames_final <- paste(c(prefijo, dfnames2), collapse = "")
      ## Cambiar el nombre de la columna "ReferenceRateUSD"
      prefijo = "RRusd_"
      dfcolnames <- paste(c(prefijo, dfnames2), collapse = "")
      colnames(dataframe2)[colnames(dataframe2) == "ReferenceRateUSD"] <- dfcolnames
      ## Formar el objeto
      assign(dfnames_final, dataframe2)
    }
  }
}

## Eliminar los dataframes residuales del bucle anterior del environment
rm(dataframe, dataframe2, col, dfcolnames, dfnames_final, dfnames2, file, prefijo)

## Generar una lista con los objetos del environment que son un dataframe
environmentlist <- Filter(is.data.frame, mget(ls()))

## Ordenar las fechas de los dataframes
environmentlist <- lapply(environmentlist, function(x) arrange(x, time))

## Juntar todos los dataframes en uno solo
criptomonedas <- reduce(environmentlist, full_join, by = "time")

## Cambiar el formato de la fecha
criptomonedas$time <- as.Date(criptomonedas$time, format = "%Y-%m-%d")

## Ordenar fechas del dataframe final
criptomonedas <- arrange(criptomonedas, time)

## Exportar datos: .Rdat, XLSX y CSV

if ("criptomonedas.xlsx" %in% dir()) {
  print(paste("No es necesario crear el XLSX, está en:", getwd()))
} else {
  write.xlsx(criptomonedas, file = "criptomonedas.xlsx")
  print(paste("Se ha guardado el archivo en:", as.character(getwd()) ))
}

## Eliminar la columna time al utilizarla como rownames
rownames(criptomonedas) <- criptomonedas[,1]
criptomonedas <- criptomonedas[, -1]


## Montar el dataframe con los rendimientos logarítmicos ----

## Creación de una función que haga el rendimiento logarítmico
tologreturns <- function(x) {
  return(log(x / lag(x, n = 1))* 100)
}

## Calcular rendimientos logarítmicos
  ## margin = 2 para seleccionar las columnas 
rendimientos <- as.data.frame(apply(criptomonedas, 2, function(x) tologreturns(x)))

## Descriptivo de todos los activos ----
# Función para obtener estadísticos

analisisdescriptivo <- function(x) {
  x <- na.omit(x) #omitir NA
  JarqueBera <- jarque.bera.test(x)
  JarqueBera <- JarqueBera$p.value
  estadisticos <- data.frame(
    "N" = length(x),
    "Media" = mean(x),
    "Standard Deviation" = sd(x),
    "Variance" = var(x),
    "Min" = min(x),
    "Max" = max(x),
    "Skewness" = skewness(x),
    "Kurtosis" = kurtosis(x),
    "Jarque Bera p value" = JarqueBera)
  return(estadisticos)
}

## Guardar los nombres de las columnas del análisis descriptivo
nombresdescriptivo<- list("N", "Media", "Standard Deviation", 
                          "Variance", "Min", "Max", "Skewness", 
                          "Kurtosis", "Jarque Bera p value")

## Crear un dataframe vacio para el summary descriptivo
descriptivo <- data.frame(matrix(ncol = length(nombresdescriptivo), nrow = 0))

## Cambiar los nombres de las columnas del dataframe vacío
colnames(descriptivo) <- nombresdescriptivo

## Loop para crear el dataframe descriptivo
for (col in colnames(rendimientos)){
  x <- analisisdescriptivo(rendimientos[[col]])
  descriptivo <- rbind(descriptivo, x)
}

## Cambiar el nombre de las filas por los de los activos
rownames(descriptivo) <- nombres2





