# Modelado e inferencia de parámetros en el vaciado de tanques mediante la ley de Torricelli

Material de clase para el curso de Ecuaciones Diferenciales Ordinarias del ciclo común de ingeniería. A partir del vaciado de un tanque cilíndrico, el estudiante resuelve una EDO separable, la linealiza con el cambio de variable $y=\sqrt{h}$ y plantea un **problema inverso**: estimar el radio efectivo de un orificio de descarga obstruido a partir de mediciones del nivel del agua.

El repositorio contiene dos versiones de la actividad, los datos y el código que reproduce todos los resultados numéricos.

| Versión | Datos | Qué evalúa además del modelado |
|---|---|---|
| [Sintética](actividades/sintetica/) | Dados en el enunciado, generados con el modelo y redondeados a 0.01 m | Recuperación de un parámetro conocido cuando la única perturbación es la resolución de la medida |
| [Experimental](actividades/experimental/) | Medidos por cada grupo con un prototipo | Diseño experimental, repeticiones, incertidumbre, calibración del coeficiente de descarga |

## Relación con el artículo

Este material acompaña al manuscrito *Modelación e inferencia de parámetros mediante la ley de Torricelli* (G. Calderón y J. C. Carrillo Escobar), en revisión en la *Revista Mexicana de Física E*. Los datos de la versión sintética son los mismos que se usan en el artículo.

## Estructura

```
actividades/
  sintetica/       enunciado (.tex, .pdf), clase LaTeX y figuras
  experimental/    enunciado (.tex, .pdf), clase LaTeX y figuras
datos/
  sinteticos/      datos de la actividad sintética y su procedimiento de generación
  experimental/    plantilla CSV para los datos que registran los grupos
codigo/
  python/          verificación numérica de la actividad sintética
  matlab/          código que reproduce las tablas y figuras del artículo
```

## Reproducir los resultados

### Python (actividad sintética)

Requisitos: Python 3.9 o superior con `numpy` (ver [`codigo/python/requirements.txt`](codigo/python/requirements.txt)).

```bash
pip install -r codigo/python/requirements.txt
python codigo/python/verificacion_actividad_sintetica.py   # resultados de la actividad sintética
```

El script de verificación incluye el ajuste por mínimos cuadrados (resuelto con las ecuaciones normales y contrastado con `numpy.polyfit`), el radio efectivo, el ECM, una integración RK4 comparada con la solución exacta y un control que regenera los datos a partir del modelo.

### MATLAB (artículo)

Los scripts de [`codigo/matlab/`](codigo/matlab/) reproducen las Tablas II, V y VI y las Figuras 3 a 6 del artículo. Requieren MATLAB R2020a o posterior y Optimization Toolbox. Ver [`codigo/matlab/README.md`](codigo/matlab/README.md). El artículo, las actividades y los dos códigos usan la misma notación para β, y MATLAB y Python dan el mismo valor de β, del radio efectivo y del tiempo de vaciado.

Para compilar los enunciados se necesita una distribución LaTeX con `babel` en español. Ejecute `pdflatex` dos veces dentro de la carpeta de cada actividad.

## Nota para docentes

El código de este repositorio resuelve la actividad sintética, porque los datos son públicos. Si usa la actividad en clase, genere otro conjunto de datos cambiando el radio efectivo en el modelo (ver [`datos/sinteticos/README.md`](datos/sinteticos/README.md)).

## Uso de inteligencia artificial

La imagen del tanque usada en ambos enunciados (`EsquemaTanqueTuberiaCorroida.png`) fue generada con inteligencia artificial y es ilustrativa. Se utilizó asistencia de IA en la redacción y revisión de los enunciados y en la escritura del código de verificación. El contenido científico y didáctico es responsabilidad del autor.

## Licencia

* Documentos, figuras y datos: [Creative Commons Atribución 4.0 Internacional (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/deed.es).
* Código: [MIT](LICENSE).

## Cómo citar

Ver [`CITATION.cff`](CITATION.cff). GitHub muestra el botón *Cite this repository* a partir de ese archivo.

## Contacto

Comentarios y correcciones: gecs.clase@gmail.com
