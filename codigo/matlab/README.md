# Código MATLAB del artículo

Scripts que reproducen las tablas y figuras del artículo *Modelación e inferencia de parámetros mediante la ley de Torricelli* (G. Calderón y J. C. Carrillo Escobar, Rev. Mex. Fís. E). Cada script es independiente: genera los datos a partir del modelo y no lee archivos externos.

| Script | Reproduce | Requisitos |
|---|---|---|
| `Fig3_linealizacion.m` | Figura 3 (Sec. 2.3) | MATLAB R2020a o posterior |
| `Fig4_Fig5_resultados.m` | Tabla II, Secs. 3.1 a 3.8, Tabla V, Figuras 4 y 5 | MATLAB R2020a o posterior, Optimization Toolbox |
| `MonteCarlo_TablaVI_Fig6.m` | Tabla VI y Figura 6 (Sec. 3.9), con semilla fija `rng(2026)` | MATLAB R2020a o posterior, Optimization Toolbox; `prctile` puede requerir Statistics and Machine Learning Toolbox en versiones antiguas |

Ejecute cada script desde esta carpeta. Las figuras se exportan en PDF vectorial y los resultados se imprimen en la consola.

## Datos

`Fig4_Fig5_resultados.m` construye la Tabla II redondeando la solución exacta a dos decimales (`CORREGIR_TABLA_II = true`). El resultado coincide con `../../datos/sinteticos/datos_actividad_sintetica.csv`.

## Notación de β

El artículo y las actividades de clase usan dos normalizaciones distintas del parámetro β:

| | Definición | Recta linealizada |
|---|---|---|
| Artículo y scripts MATLAB | $\beta = C_d\,\dfrac{\pi r^2}{A}\sqrt{2g}$ | $\sqrt{h} = \sqrt{h_0} - \dfrac{\beta}{2}\,t$ |
| Actividades y script de Python | $\beta = \dfrac{1}{2}\,C_d\,\dfrac{r^2}{R^2}\sqrt{2g}$ | $\sqrt{h} = \sqrt{h_0} - \beta\,t$ |

Por tanto, $\beta_{\text{artículo}} = 2\,\beta_{\text{actividad}}$. El radio estimado, el ECM y el tiempo de vaciado no dependen de la normalización y coinciden en ambos códigos.
