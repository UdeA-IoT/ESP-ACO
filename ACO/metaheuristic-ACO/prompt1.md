Contexto del proyecto: ESP-ACO (UdeA). Fuente primaria: aco-book.pdf
(Dorigo & Stützle, MIT Press 2004), capítulos 2 y 3. Registro formal en
español, documentación GFM para GitHub, uso de fences ```math para
ecuaciones y fences ```mermaid para diagramas (ambos se renderizan
nativamente en GitHub).

Tarea: generar un documento Markdown de estudio, autocontenido, que
explique de forma pedagógica (destinatario: principiante en el tema,
sin base previa en teoría de grafos, complejidad computacional ni
algoritmos voraces/de búsqueda local) los siguientes conceptos, en
este orden:

1. Qué es un problema de optimización combinatoria y por qué es
   difícil de resolver (incluir figura de crecimiento polinomial
   vs. exponencial).
2. Definición formal de un problema de optimización combinatoria
   como tripleta (S, f, Ω), y el planteamiento formal del TSP a
   partir de esa definición, con un mini-ejemplo numérico de 4
   ciudades resuelto paso a paso (incluir figura comparando el tour
   óptimo contra un tour cruzado).
3. Cómo se resuelven estos problemas: métodos exactos vs.
   aproximados (constructivos y de búsqueda local).
4. Aspectos a considerar al resolverlos (representación, función
   objetivo, restricciones, vecindad, conocimiento del problema,
   estático/dinámico, costo computacional).
5. Relación entre heurística y metaheurística, con ejemplos de cada
   una y un diagrama Mermaid que muestre la jerarquía
   heurística/metaheurística y su conexión con ACO.
6. Búsqueda local y el movimiento 2-opt explicado paso a paso, con:
   - Definiciones previas de vecindad y óptimo local.
   - Pseudocódigo del algoritmo.
   - Aplicación sobre el mismo mini-ejemplo de 4 ciudades.
   - Aplicación sobre un segundo ejemplo más rico (5-6 ciudades)
     que muestre varias iteraciones de mejora, cada una con una
     figura "antes/después" mostrando qué arcos se eliminan y el
     costo del tour en cada paso, más una tabla resumen de la
     evolución de costos.

Restricciones de formato:
- Idioma: español formal.
- Formato: GitHub-Flavored Markdown, con índice al inicio, fences
```math para ecuaciones, fences ```mermaid para el diagrama de la
  sección 5 (no como imagen).
- Figuras numéricas (TSP, complejidad, evolución 2-opt): generarlas
  computacionalmente (no ilustraciones a mano), guardarlas como
  archivos .svg independientes, y referenciarlas en el markdown con
  rutas relativas figures/<nombre>.svg — el markdown se sube a
  GitHub y las imágenes se colocan manualmente en esa carpeta.
- Honestidad epistemológica: distinguir explícitamente qué contenido
  proviene del libro (aco-book.pdf) y qué proviene de fuentes web
  complementarias o de ejemplos generados/verificados
  computacionalmente para el documento, citando fuentes al final sin
  reproducir texto textual de ellas (límites de copyright: máximo
  una cita corta por fuente, <15 palabras).
- Todos los valores numéricos de los ejemplos deben verificarse por
  cómputo directo (no calculados "a mano" sin chequeo) antes de
  incluirse en el documento.

Andamiaje pedagógico: antes de generar el documento, calibrar el
nivel de la explicación con preguntas breves sobre conocimientos
previos (teoría de grafos, notación O grande, algoritmos
voraces/búsqueda local) y, si el alcance o las convenciones de
nombres de archivo no son evidentes, preguntar antes de generar el
documento final.
