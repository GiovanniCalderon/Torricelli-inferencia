# Datos de la actividad sintética

Archivo: `datos_actividad_sintetica.csv`

| Columna | Descripción | Unidades |
|---|---|---|
| `t_s` | tiempo desde el inicio del drenaje | s |
| `h_m` | altura del agua sobre el centro del orificio | m |

## Procedimiento de generación

Los datos se obtuvieron evaluando la solución exacta del modelo de Torricelli,

$$h(t)=\left(\sqrt{h_0}-\beta t\right)^2,\qquad \beta=\tfrac{1}{2}C_d\,\frac{r^2}{R^2}\sqrt{2g},$$

con los parámetros

| Parámetro | Valor |
|---|---|
| radio efectivo real $r$ | 0.035 m |
| radio del tanque $R$ | 2.5 m |
| coeficiente de descarga $C_d$ | 0.61 |
| gravedad $g$ | 9.81 m/s² |
| altura inicial $h_0$ | 10.0 m |
| instantes | 0 a 3600 s cada 300 s |

y redondeando cada valor a dos cifras decimales, lo que representa la resolución de 0.01 m de un sensor de nivel. No se añadió ninguna otra perturbación.

## Nota de versión

En versiones anteriores del artículo y de la actividad, el dato en t = 2400 s aparecía como 6.39 m. El modelo da h(2400) = 6.3846 m, cuyo redondeo correcto es 6.38 m, que es el valor que contiene este archivo. Con él, los trece datos coinciden exactamente con el modelo redondeado.

## Generar un conjunto nuevo para clase

Para usar la actividad sin que los resultados publicados sirvan de solución, cambie el radio efectivo $r$ (por ejemplo, a un valor entre 0.025 y 0.038 m) y vuelva a evaluar y redondear el modelo.
