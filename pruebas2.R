## Eliminar la columna time al utilizarla como rownames
rownames(criptomonedas) <- criptomonedas[,1]
criptomonedas <- criptomonedas[, -1]
copia <- criptomonedas


## Creación de una función que haga el rendimiento logarítmico
tologreturns <- function(x) {
  return(log(x / lag(x, n = 1))* 100)
}

rendimientos <- as.data.frame(apply(criptomonedas, 2, function(x) tologreturns(x)))


# Cargar paquete e1071
library(e1071) #estadisticos
library(tseries) #estadisticos

# Obtener estadísticos

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

## Loop para crear el dataframe
for (col in colnames(criptomonedas)){
  x <- analisisdescriptivo(criptomonedas[[col]])
  descriptivo <- rbind(descriptivo, x)
}

## Cambiar el nombre de las filas por los de los activos
rownames(descriptivo) <- nombres2


