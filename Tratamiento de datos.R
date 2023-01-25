## Librerias ----
library("dplyr")
library("readr")
library("plyr")
library("fs") #para ubicar el directorio de los csv
library("lubridate") #bucle for
library("purrr") #fulljoin method
library("stringr") #environmentlist filter

## Directorios de los archivos ----
setwd("/home/filibustero/Documentos/TFM/cryptocurrency-market-efficiency/csv221022") # TFM
#setwd("/home/filibustero/Documentos/R/Pruebas/Pruebas/tfm") # Muestra

## Lectura del directorio en busca de CSV ----
files <- dir(pattern = "*.csv")

## Bucle que crea objetos diferentes para cada CSV ----
for(file in files){
  dataframe <- read.csv(file, stringsAsFactors = FALSE)
  for(col in colnames(dataframe)){#checknombrecolumna
    if(col != "PriceUSD"){
    }
    else{
      ## Primero montar los dataframes y elegir solo dos columnas
      dataframe2 <- read.csv(file, stringsAsFactors = FALSE)
      dataframe2 <- dataframe2[c("time", "PriceUSD")]
      ## Configurar el nombre del objeto a "df_file"
      dfnames2 <- as.character(gsub("\\.csv$", "", file))
      prefijo <- as.character("df_")
      dfnames_final <- paste(c(prefijo, dfnames2), collapse = "")
      ## Cambiar el nombre de la columna "PriceUSD"
      prefijo = "Price"
      dfcolnames <- paste(c(prefijo, dfnames2), collapse = "")
      colnames(dataframe2)[colnames(dataframe2) == "PriceUSD"] <- dfcolnames
      ## Formar el objeto
      assign(dfnames_final, dataframe2)
    }
  }
}

## Eliminar los dataframes residuales del bucle anterior del environment ----
rm(dataframe, dataframe2, col, dfcolnames, dfnames_final, dfnames2, file, prefijo)

## Generar una lista con los objetos del environment que son un dataframe ----
environmentlist <- Filter(is.data.frame, mget(ls()))

## Ordenar las fechas de los dataframes ----
environmentlist <- lapply(environmentlist, function(x) arrange(x, time))

## Juntar todos los dataframes en uno solo ----
df_final <- reduce(environmentlist, full_join, by = "time")

## Cambiar el formato de la fecha ----
df_final$time <- as.Date(df_final$time, format = "%Y-%m-%d")

## Ordenar fechas del dataframe final ----
df_final <- arrange(df_final, time)

## Exportar datos: .Rdat, XLSX y CSV ----

