library("dplyr")
library("readr")
library("plyr")
library("fs")
library("lubridate")
library("purrr")

## MINI EJEMPLO PERFECTO ----
### Genera dos archivos csv que cumplen con las características del conjunto de csv
write_csv(read_csv("01/01/2022, 2 \n 01/02/2022, 4", col_names = c("date", "price1")), 
          file = "file1.csv")

write_csv(read_csv("01/02/2022, 6 \n 01/02/2022, 8", col_names = c("date", "price2")), 
          file = "file2.csv")

write_csv(read_csv("01/05/2022, 6, devaluated \n 01/02/2022, 8, devaluated", col_names = c("date", "price3", "status")), 
          file = "file3.csv")

### Lectura del directorio en busca de cualquier csv y guarda el resultado 
files <- dir_ls(".", glob = "*.csv")

### Coge todos los csv del directorio files y los lee
df <- lapply(files, read_csv)

### Juntar por filas
df <- bind_rows(df)

### Cambiar el formato de la fecha
df$date <- as.Date(df$date, format = "%m/%d/%Y")

## PRUEBAS CON LOS DATOS OBJETIVO #######################

## Prueba 1: Cada elemento de temp_df es un dataframe, uno por cada csv en el directorio
csvs <- list.files(path = "/home/filibustero/Documentos/TFM/cryptocurrency-market-efficiency/csv221022", pattern = "*.csv", full.names = TRUE)

temp_df <- lapply(csvs, read_csv)

## Prueba 2: Sigue sin concatenar bien los elementos, además no distingue entre  csvs con/sin columna PriceUSD
csvs <- list.files(path = "/home/filibustero/Documentos/TFM/cryptocurrency-market-efficiency/csv221022", 
                   pattern = "*.csv", full.names = TRUE) %>% 
  lapply(read_csv) %>%										
  bind_rows

## Prueba 3: 
### Objetivo: Leer menos CSVs y tratar de minimizar el problema

mincsv <- list.files(path = "/home/filibustero/Documentos/R/Pruebas/Pruebas/tfm", 
                     pattern = "*.csv", full.names = TRUE) %>% 
  lapply(read_csv) %>% 								
  bind_rows

### Siguiente paso: Modificar parámetros de lectura: seleccionar columnas

mincsv <- list.files(path = "/home/filibustero/Documentos/R/Pruebas/Pruebas/tfm", 
                   pattern = "*.csv", full.names = TRUE)

mincsv <- lapply(mincsv, read_csv)
mincsv <- mincsv[["time","PriceUSD"]]
mincsv[c("time", "PriceUSD")]

asset1 <- as.data.frame(mincsv[1])
asset1 <- asset1[c("time", "PriceUSD")]
asset1 <- asset1 %>% dplyr::rename("1inch" = PriceUSD)

asset2 <- as.data.frame(mincsv[2])
asset2 <- asset2[c("time", "PriceUSD")]
asset2 <- asset2 %>% dplyr::rename(aave = PriceUSD)

assetTotal <- bind_rows(asset1, asset2)

### Tratar de obtener un dataframe por cada elemento del directorio
#### Guarda los objetos bien pero el nombre de los archivos no sale bien
mincsv <- list.files(path = "/home/filibustero/Documentos/R/Pruebas/Pruebas/tfm", 
                     pattern = "*.csv", full.names = TRUE)

for(file in mincsv){
  assign(gsub("\\.csv", "", file), read_csv(file))
}

### Otro intento de lo anterior: Funciona mejor

files <- dir(pattern = "*.csv")

for(file in files){
  dataframe <- read.csv(file, stringsAsFactors = FALSE)
  assign(gsub("\\.csv$", "", file), dataframe)
}

final_df <- full_join(file1,file2, by = "date") %>%
  full_join(file3, by = "date")

### Tratar de replicar con mincsv

setwd("/home/filibustero/Documentos/R/Pruebas/Pruebas/tfm")

files <- dir(pattern = "*.csv")
prefijo <- as.character("df_")

for(file in files){
  dataframe <- read.csv(file, stringsAsFactors = FALSE)
  dfnames <- as.character(gsub("\\.csv$", "", file))
  dfnames <- paste(c(prefijo, dfnames), collapse = "")
  assign(dfnames, dataframe)
}

final_df <- full_join(df_1inch, df_aave, by = "time")

### Mejorar el bucle: Parece que funciona, probar con todos los CSVS

rm(list=ls())

setwd("/home/filibustero/Documentos/R/Pruebas/Pruebas/tfm")

files <- dir(pattern = "*.csv")

nombres = list()

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
      nombres <- append(nombres, dfnames2)
      ## Cambiar el nombre de la columna "PriceUSD"
      prefijo = "Price"
      dfcolnames <- paste(c(prefijo, dfnames2), collapse = "")
      colnames(dataframe2)[colnames(dataframe2) == "PriceUSD"] <- dfcolnames
      ## Formar el objeto
      assign(dfnames_final, dataframe2)
    }
  }
  #dfnames <- as.character(gsub("\\.csv$", "", file))
  #dfnames <- paste(c(prefijo, dfnames), collapse = "")
  #assign(dfnames, dataframe)
}

final_df <- full_join(df_1inch, df_aave, by = "time")

### Probar todos los CSVs del directorio del TFM
rm(list=ls())

setwd("/home/filibustero/Documentos/TFM/cryptocurrency-market-efficiency/csv221022")

files <- dir(pattern = "*.csv")

df_list <- list()
nombres = list()

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
      nombres <- append(nombres, dfnames2)
      ## Cambiar el nombre de la columna "PriceUSD"
      prefijo = "Price"
      dfcolnames <- paste(c(prefijo, dfnames2), collapse = "")
      colnames(dataframe2)[colnames(dataframe2) == "PriceUSD"] <- dfcolnames
      ## Formar el objeto
      assign(dfnames_final, dataframe2)
      ## Guardar en una lista todos los CSV como dataframe
      dflist <- append(dflist, dataframe2)
    }
  }
  #dfnames <- as.character(gsub("\\.csv$", "", file))
  #dfnames <- paste(c(prefijo, dfnames), collapse = "")
  #assign(dfnames, dataframe)
}

df_merged <- reduce(df_list, full_join, by = "time")
final_df <- full_join(df_1inch, df_aave, by = "time")

