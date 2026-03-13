#Practica gmilitar
#Cruz Peña Mario Alberto
#install.packages('readr')

library(readr)
gmilitar <- read_csv("C:/Users/EQUIPO/Downloads/gmilitar.csv")
View(gmilitar)

militar<-gmilitar
ls(militar)

plot(militar$X2,
     militar$Y,
     las=1)


#Regresion lineal
linear_regression<-lm(Y~X2, #Y=a+mX2
                      data=militar)

abline(linear_regression,
       col='red',
       lwd=2)
grid()

install.packages("lmtest")
library(lmtest)
library(tseries)

jarque.bera.test(militar$Y)

#X-squared =5.199<5.69   p value=0.07431>0.05  por lo tanto se distribuye
# de manera normal

hist(militar$Y)

ModeloMCO<-lm(Y~X2+X3+X4+X5,
             data=militar)

summary(ModeloMCO)

error<-ModeloMCO$residuals
error

library(moments)
jarque.test(error) # JB=4,8912  p-value=0.08668
jarque.bera.test(error) #x-squared=4.89   df=2 p-value=0.08668 
hist(error)

boxplot(error,
        col='purple',
        las=1)

#TABLA ANOVA
anova(ModeloMCO)  #F = 489.45 es muy alto por lo tanto tiene mayor
#imapcto en la variable dependiente

summary(ModeloMCO)

#Modelo sin Intercepto
ModeloMCO<-lm(Y~X2-1,
              data=militar)
summary(ModeloMCO)

# La variable X2  tiene efecto positivo sobre Y
#El error estandar es bajo =0.002565
# Los datos se desvian muy poco de la linea de regresion 17.55 en 19
# Por cada aumneto de una unidad X2 el valor de Y aumneta en promedio
# 0.0567 unidades
# R-squared=0.9626 significa que el 96.26% de la variacion de Y se explica
#por X2 indica que el modelo se explica muy bien



#Modelo con intercepto
ModeloMCO<-lm(Y~X2,
              data=militar)
summary(ModeloMCO)


#Con intercepto tiene menor error estandar residual 9.1 vs 17.55 da mas precision
# Ambas maneras no se distinguen mucho en sus resultados pero con intercepto es 
# mas precision