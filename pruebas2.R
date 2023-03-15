## Eliminar la columna time al utilizarla como rownames
rownames(criptomonedas) <- criptomonedas[,1]
criptomonedas <- criptomonedas[, -1]

## Prueba de operación
prueba <- apply(criptomonedas, 2, function(x) x * 3)

## Prueba de diferencia

apply(criptomonedas, 2, diff(log(criptomonedas)))

## Calcular los rendimientos logarítmicos


df <- data.frame(A = c(10, 20, 30, 40), 
                 B = c(5, 10, 15, 20), 
                 C = c(1, 2, 4, 8))

apply(df, 2, function(x) c(NA, x[-1] / x[-length(x)]))

apply(df, 2, function(x) c(NA, log(x[-1] / x[-length(x)])))
