# Notebook: Optimización combinatoria y TSP — método exacto y búsqueda local (2-opt)

**Archivo:** `notebooks/optimizacion-combinatoria-tsp.ipynb`
**Badge:** `[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](<URL_PLACEHOLDER>)`
  (URL placeholder — tú la ajustas al link definitivo del repo)
**Librerías:** pandas, numpy, itertools, networkx, matplotlib, math
**Idioma:** español formal, coherente con las notas del proyecto y con
`optimizacion-combinatoria-2opt.md`

---

## Sección 0 — Portada
- Título, badge de Colab, breve descripción y enlace al documento
  `optimizacion-combinatoria-2opt.md` como referencia teórica complementaria.

## Sección 1 — Definición formal (celdas Markdown, LaTeX nativo de Jupyter)
- Definición de la tripleta (S, f, Ω): soluciones candidatas, función
  objetivo, restricciones, soluciones factibles S̃, óptimo global S*.
- Traslado formal al TSP: qué es S, Ω y f concretamente en este problema
  (permutaciones, circuito hamiltoniano, longitud del recorrido).
- Se reutiliza la misma notación que ya usamos en el markdown de estudio,
  para que ambos documentos sean consistentes entre sí.

## Sección 2 — Planteamiento del mini-ejemplo (4 ciudades)
- Definición de coordenadas (A, B, C, D — cuadrado de lado 10).
- Matriz de distancias como `pandas.DataFrame` (filas/columnas = ciudades).
- Grafo asociado G=(N,A) dibujado con `networkx`: nodos = ciudades, aristas
  = todas las conexiones posibles (grafo completo), con los pesos (d_ij)
  como etiquetas.

## Sección 3 — Método exacto: enumeración completa
- Generación de **todas** las combinaciones válidas con `itertools.permutations`,
  reducidas a los tours distintos (fijando ciudad de inicio, sin contar
  reversos repetidos) → esto es S explícitamente construido.
- Cálculo de f(π) para cada tour → tabla en `pandas.DataFrame` con columnas:
  tour, secuencia de arcos, costo total — y una columna booleana que marca
  cuál es S* (el óptimo).
- Conexión explícita con la Sección 1: se señala en el notebook, para cada
  fila del DataFrame, a qué elemento de S corresponde y por qué todas son
  factibles (S̃ = S en este caso, ya que la única restricción — visitar cada
  ciudad una vez — ya está garantizada por construcción de las permutaciones).
- Visualización: subplots con `networkx`, uno por cada tour candidato,
  resaltando en color el circuito sobre el grafo; el óptimo (S*) resaltado
  de forma distinta (p. ej. color verde vs. gris para los demás).
- Gráficas descriptivas: gráfico de barras comparando el costo de los 3
  tours; mapa de calor (`heatmap`) de la matriz de distancias.

## Sección 4 — Búsqueda local: 2-opt sobre el ejemplo de 6 ciudades (hexágono)
- Reutiliza el ejemplo de 6 ciudades del markdown de estudio (mismo tour
  inicial "enredado", mismas coordenadas) para mantener consistencia entre
  ambos documentos.
- Definiciones operativas paso a paso: vecindad, movimiento 2-opt, óptimo
  local — recordadas brevemente antes del código (celdas Markdown).
- Implementación en Python: funciones `tour_length`, `two_opt_step` (busca
  el mejor intercambio en cada iteración), bucle principal que guarda el
  historial de cada paso.
- Tabla en `pandas.DataFrame`: una fila por paso, con columnas: arcos
  eliminados, arcos nuevos, tour resultante, costo antes/después,
  mejora absoluta y porcentual.
- Visualización paso a paso con `networkx`: un subplot por iteración,
  arcos eliminados resaltados en rojo (punteado) y el tour resultante
  en verde — igual que en las figuras del markdown de estudio, pero
  generado en vivo dentro del notebook.
- Gráfica descriptiva final: curva de convergencia (costo del tour vs.
  número de iteración de 2-opt).

## Sección 5 — Conclusiones
- Síntesis breve: qué muestra el método exacto vs. la búsqueda local,
  costo computacional de cada uno en este ejemplo, y el enlace conceptual
  con ACO (próximo tema del proyecto).

## Sección 6 — Referencias para profundizar
- Dorigo, M. & Stützle, T. (2004). *Ant Colony Optimization*. MIT Press.
  Cap. 2 y 3.
- Croes, G. A. (1958). *A method for solving traveling-salesman problems*.
  Operations Research — artículo original que propone el movimiento 2-opt.
- Documentación oficial de NetworkX sobre aproximaciones al TSP
  (`networkx.algorithms.approximation.traveling_salesman`).
- Artículo con implementación completa en Python de fuerza bruta con
  NetworkX, pandas y matplotlib para TSP ("Solving the Travelling
  Salesperson Problem (TSP) in Python", D. Lopez Yse, Medium) — enfoque
  muy cercano al que usaremos en la Sección 3.
- Comparativa de heurísticas 2-opt/3-opt en Python (blog de Matej Gazda).