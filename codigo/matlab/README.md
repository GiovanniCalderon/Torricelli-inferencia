# Código MATLAB del artículo

Scripts que reproducen las tablas y figuras del artículo *Modelación e inferencia de parámetros mediante la ley de Torricelli* (G. Calderón y J. C. Carrillo Escobar, Rev. Mex. Fís. E). Cada script es independiente: genera los datos a partir del modelo, sin depender de otros archivos.

| Script | Reproduce | Requisitos |
|---|---|---|
| `Fig3_linealizacion.m` | Figura 3 (Sec. 2.3) | MATLAB R2020a o posterior |
| `Fig4_Fig5_resultados.m` | Tabla II, Secs. 3.1 a 3.8, Tabla V, Figuras 4 y 5 | MATLAB R2020a o posterior, Optimization Toolbox |
| `MonteCarlo_TablaVI_Fig6.m` | Tabla VI y Figura 6 (Sec. 3.9), con semilla fija `rng(2026)` | MATLAB R2020a o posterior, Optimization Toolbox; `prctile` puede requerir Statistics and Machine Learning Toolbox según la versión |

Ejecute cada script desde esta carpeta. Las figuras se exportan en PDF vectorial y los resultados se imprimen en la consola.

## Datos

`Fig4_Fig5_resultados.m` construye la Tabla II redondeando a dos decimales la solución exacta con $r_{\text{real}} = 0.035$ m y, si se ejecuta desde esta carpeta, comprueba que coincide con `../../datos/sinteticos/datos_actividad_sintetica.csv`. `MonteCarlo_TablaVI_Fig6.m` parte de la solución exacta sin redondear y le añade ruido multiplicativo (Sec. 3.9 del artículo).

## Notación de β

El artículo, las actividades de clase y los dos códigos usan la misma definición,

$$\beta = C_d\,\frac{r^2}{R^2}\sqrt{2g}, \qquad \frac{dh}{dt} = -\beta\sqrt{h}, \qquad \sqrt{h(t)} = \sqrt{h_0} - \frac{\beta}{2}\,t,$$

de modo que la pendiente de la recta ajustada es $-\beta/2$. Con los datos de la actividad sintética, `Fig4_Fig5_resultados.m` y `../python/verificacion_actividad_sintetica.py` dan el mismo valor, $\beta_{\text{est}} = 5.2933\times10^{-4}$ m$^{1/2}$/s.
