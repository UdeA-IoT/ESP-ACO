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
- Generación de