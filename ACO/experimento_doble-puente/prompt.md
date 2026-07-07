Genera un Jupyter Notebook (.ipynb) en español que resuma, de forma pedagógica y
reproducible, el proceso completo de deducción del modelo probabilístico de
Deneubourg et al. (1990) para el experimento del puente doble, tal como aparece
citado en Dorigo & Stützle, "Ant Colony Optimization" (MIT Press, 2004), capítulo 1,
secciones 1.1.2 y ejercicio 1.5.

Estructura el notebook alternando celdas markdown (explicación teórica, estilo
"profesor deduciendo paso a paso", con las fórmulas en LaTeX) y celdas de código
(matplotlib para graficar, sympy para verificar simbólicamente).

Incluye estas secciones, en este orden:

0. Encabezado con botón de Colab
   - Primera celda markdown del notebook: un badge/botón "Open in Colab" enlazando
     a https://colab.research.google.com/github/USUARIO/REPO/blob/main/NOMBRE_NOTEBOOK.ipynb
     Dejar USUARIO, REPO y NOMBRE_NOTEBOOK como placeholders explícitos (los
     completaré yo manualmente una vez suba el notebook a su repositorio). Usar el
     badge estándar de shields.io:
     [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/USUARIO/REPO/blob/main/NOMBRE_NOTEBOOK.ipynb)

1. Objetivos
   - Celda markdown con una lista corta (4-6 puntos) de objetivos de aprendizaje
     del notebook, formulados como logros verificables (ej. "deducir la fórmula 1.1
     desde el mecanismo causal de retroalimentación por feromona", "determinar
     analíticamente la estabilidad de los puntos fijos del caso estacionario").

2. Introducción y contexto
   - Breve resumen del experimento del puente doble (Deneubourg, Goss, Aron,
     Pasteels) y por qué es la base histórica del algoritmo ACO.
   - Cita la fórmula 1.1 del libro: p_is(t) = (t_s+φ_is(t))^α / [(t_s+φ_is(t))^α + (t_s+φ_il(t))^α]

3. El modelo de elección discreto (versión simplificada, ejercicio 1.5)
   - Deducción breve en markdown de p_s = m_s^n / (m_s^n + m_l^n)
   - Celda de código: graficar p1 en función de (m1 - m2) para n=1,2,4, replicando
     la curva de amplificación (S más pronunciada para n mayor). Usar matplotlib,
     con leyenda y ejes etiquetados en español.

4. Dinámica temporal con retardo (ecuaciones 1.2 y 1.3)
   - Explicación en markdown del retardo t_s y r·t_s, y por qué aparece un término
     "sin retardo" (salida propia) y uno "con retardo" (llegada del otro extremo).
   - Celda de código: simulación numérica simplificada (discretización en el tiempo,
     sin necesidad de un solver de ecuaciones con retardo especializado) mostrando
     cómo φ_is(t) y φ_il(t) crecen de forma distinta según la rama elegida.

5. Caso estacionario y análisis de estabilidad
   - Deducción en markdown de la ecuación de punto fijo p_s = p_s^α/(p_s^α+(1-p_s)^α)
     y de f'(1/2) = α.
   - Celda de código con sympy: derivar f(p) simbólicamente, evaluar en p=1/2 y
     confirmar que da α, para verificar la deducción hecha a mano.
   - Celda de código con matplotlib: recrear el diagrama de punto fijo (curva f(p)
     vs. diagonal f(p)=p), marcando p=0 y p=1 como estables y p=0.5 como inestable,
     con flechas indicando la dirección de convergencia.

6. Ejercicios de repaso (opcional, si hay un README de ejercicios adjunto)
   - Para cada uno de los 4 ejercicios de estabilidad de puntos fijos, incluir una
     celda de código con sympy que verifique simbólicamente la respuesta calculada
     a mano.

7. Conclusiones
   - Celda markdown final que (a) resuma el método general de modelado en 5 pasos
     (observar → variables de estado → mecanismo causal → traducir a símbolos →
     verificar contra datos), conectándolo explícitamente con cada sección anterior
     del notebook, y (b) responda punto por punto a cada objetivo planteado en la
     sección 1, indicando qué se logró y con qué evidencia (fórmula deducida,
     verificación simbólica, gráfica generada).

Requisitos técnicos del notebook:
- Usar solo numpy, matplotlib y sympy (evitar dependencias no estándar).
- Todas las gráficas con ejes, títulos y leyendas en español.
- Código comentado, legible, sin una sola celda gigante — una celda por gráfica o
  cálculo simbólico.
- El tono debe ser el de un cuaderno de estudio personal, no una publicación
  formal: directo, sin relleno, priorizando claridad sobre exhaustividad.

Además del notebook, genera un archivo README.md independiente que incluya:
- Una descripción breve (2-3 párrafos) de qué contiene el notebook y de dónde
  viene el material (Dorigo & Stützle, cap. 1, con referencia a Deneubourg et al. 1990).
- Instrucciones de ejecución local: requisitos (Python 3.x, pip install numpy
  matplotlib sympy jupyter), y el comando para abrirlo (jupyter notebook
  NOMBRE_NOTEBOOK.ipynb).
- Una sección "Ejecutar en Colab" con el mismo badge/enlace placeholder que en el
  notebook, y una nota de una línea explicando que basta con actualizar
  USUARIO/REPO/NOMBRE_NOTEBOOK una vez esté en el repositorio.
- Un índice de contenidos del notebook (lista de secciones, para navegación rápida).