library("dplyr")               
library("plyr")                     
library("readr")

csvs <- list.files(path = "/home/filibustero/Documentos/TFM/cryptocurrency-market-efficiency/csv221022", pattern = "*.csv", full.names = TRUE)

temp_df <- lapply(csvs, read_csv)

