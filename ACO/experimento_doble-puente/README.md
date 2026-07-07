# Deducción del modelo de Deneubourg — puente doble

## Qué contiene

Este repositorio incluye un Jupyter Notebook (`deneubourg_puente_doble.ipynb`) que resume, de forma pedagógica y reproducible, el proceso completo de deducción del modelo probabilístico de Deneubourg, Aron, Goss & Pasteels (1990) para el experimento del puente doble — el origen biológico del algoritmo de optimización por colonia de hormigas (ACO).

El material sigue la fórmula 1.1 y las ecuaciones 1.2–1.3 tal como aparecen citadas en Dorigo, M. & Stützle, T., *Ant Colony Optimization*, MIT Press (2004), capítulo 1, sección 1.1.2, además del modelo discreto simplificado planteado en el ejercicio 1.5 del mismo libro.

El notebook alterna explicación teórica (con las deducciones paso a paso en LaTeX) y celdas de código que grafican los resultados y verifican simbólicamente cada paso con `sympy`: el efecto de amplificación no lineal, la simulación de la dinámica con retardo temporal, y el análisis de estabilidad de los puntos fijos del caso estacionario.

## Índice de contenidos del notebook

0. Botón de ejecución en Colab
1. Objetivos
2. Introducción y contexto (fórmula 1.1)
3. El modelo de elección discreto (ejercicio 1.5)
4. Dinámica temporal con retardo (ecuaciones 1.2–1.3)
5. Caso estacionario y análisis de estabilidad
6. Ejercicios de repaso — verificación simbólica
7. Conclusiones

## Cómo ejecutarlo localmente

Requisitos: Python 3.x

```bash
pip install numpy matplotlib sympy jupyter
jupyter notebook deneubourg_puente_doble.ipynb
```

## Ejecutar en Colab

Usa el badge de arriba, o abre directamente:

```
https://colab.research.google.com/github/USUARIO/REPO/blob/main/NOMBRE_NOTEBOOK.ipynb
```

Solo es necesario actualizar `USUARIO/REPO/NOMBRE_NOTEBOOK` con la ruta real una vez el notebook esté alojado en su repositorio de GitHub — no requiere ningún otro cambio para funcionar en Colab.

## Material relacionado

- `estabilidad_puntos_fijos.md` — guía de ejercicios de práctica sobre estabilidad de puntos fijos (con respuestas), cuyas soluciones se verifican simbólicamente en la sección 5 de este notebook.
- https://imada.sdu.dk/u/marco/Teaching/AY2016-2017/DM841/
