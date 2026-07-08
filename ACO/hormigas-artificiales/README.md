# Estudio del modelo de Deneubourg del puente doble (origen del ACO)

Material de estudio, autocontenido y reproducible, sobre el modelo probabilístico del **experimento del puente doble** de Deneubourg y colaboradores (1990) — el origen biológico del algoritmo de optimización por colonia de hormigas (ACO) — siguiendo el capítulo 1 de Dorigo & Stützle, *Ant Colony Optimization* (MIT Press, 2004).

Esta carpeta combina **un documento teórico** con **cuatro notebooks** que van de la deducción matemática a la validación estadística. Para que el recorrido no dé saltos, conviene leerlos en el orden de abajo.

---

## Ruta de lectura recomendada (de lo conceptual a lo empírico)

| # | Material | Qué aporta |
|---|---|---|
| 1 | **[`modelo_estocastico_a_discreto.md`](modelo_estocastico_a_discreto.md)** (documento teórico) | La base conceptual: la fórmula 1.1, la dinámica con retardo (1.2/1.3), el modelo discreto simple (ejercicio 1.5) y la tabla comparativa. **Empieza por aquí.** |
| 2 | `deneubourg_puente_doble.ipynb` | Verificación **determinista**: integra 1.2/1.3, deduce el punto fijo y comprueba con `sympy` que $f'(1/2)=\alpha$. Es la contraparte computacional del §2.4 del documento teórico. |
| 3 | `experimento_doble_puente.ipynb` | **Intuición interactiva** de una sola corrida: hormigas que deciden al azar con *sliders* de $r$ y $\alpha$. Deja *sentir* la dinámica de 1.1–1.3. |
| 4 | `simulacion_montecarlo_intro.ipynb` | Enseña el **método de Montecarlo** con el ejemplo clásico de estimar $\pi$ lanzando puntos al azar. Es la herramienta que se usa en el paso 5, presentada primero en aislamiento. |
| 5 | `montecarlo_aco.ipynb` | **Montecarlo aplicado al puente doble**: corre ~1000 colonias y grafica el histograma del tráfico final (estilo Figura 1.4 del libro). Es la **validación estadística** del caso estocástico. |

> [!TIP]
> **La costura entre la teoría y Montecarlo (por qué el orden no es brusco).** El documento teórico prueba *analíticamente* que el reparto 50/50 es un equilibrio inestable ($f'(1/2)=\alpha>1$). Los notebooks 4 y 5 muestran *empíricamente* ese mismo hecho: al repetir el experimento estocástico miles de veces, casi ninguna colonia termina en 50/50; con ramas iguales ($r=1$) el histograma forma una "U" (converge a una u otra rama al azar), y con la rama larga al doble ($r=2$) se amontona en el tráfico alto de la rama corta. **No es un tema nuevo: es el resultado analítico visto por la vía estadística.**

---

## Los materiales en detalle

### Documento teórico

- **`modelo_estocastico_a_discreto.md`** — Recorrido autocontenido del caso estocástico continuo (§1.1.2 del libro) al caso discreto simple (ejercicio 1.5), con glosario, tabla comparativa y un mapa de ecuaciones para leerlo sin el libro a mano. Incluye la aclaración del doble papel de $t_s$ (offset en 1.1 y tiempo de cruce en 1.2/1.3). No introduce todavía el modelo de grafo (ecuaciones 1.4–1.7), que queda para un documento posterior.

### Notebooks

- **`deneubourg_puente_doble.ipynb`** — Campo medio determinista + verificación simbólica con `sympy`. Cubre: efecto de amplificación de $\alpha$/$n$, dinámica con retardo (los dos términos de 1.2/1.3), ecuación de punto fijo, estabilidad, y 4 ejercicios de repaso.
- **`experimento_doble_puente.ipynb`** — Agente estocástico interactivo (una corrida, con *sliders*). Orientado a la intuición; usa un esquema simplificado de depósito al llegar.
- **`simulacion_montecarlo_intro.ipynb`** — Introducción al método de Montecarlo estimando $\pi$ (puntos aleatorios en un cuadrado que encierra un círculo). Puente conceptual: *azar repetido → estadística*.
- **`montecarlo_aco.ipynb`** — Une el modelo estocástico del puente doble con Montecarlo: ~1000 colonias completas y su histograma de resultados. Es autocontenido (repite las ecuaciones 1.1–1.3) y sirve de validación estadística.

---

## Cómo ejecutar

### Localmente

Requisitos: Python 3.x

```bash
pip install numpy matplotlib sympy jupyter ipywidgets
jupyter notebook
```

Los notebooks interactivos (`experimento_doble_puente`, `simulacion_montecarlo_intro`, `montecarlo_aco`) requieren `ipywidgets`.

### En Colab

Sustituye `<NOTEBOOK>` por el nombre del archivo:

```
https://colab.research.google.com/github/UdeA-IoT/ESP-ACO/blob/main/ACO/experimento_doble-puente/<NOTEBOOK>.ipynb
```

---

## Notas y deuda conocida

> [!NOTE]
> Estas notas están al día con lo revisado hasta ahora; se documentan en lugar de ocultarse.
> - **Doble papel de $t_s$.** `montecarlo_aco.ipynb` lo trata de forma **consistente**: usa el mismo $t_s = 20$ como offset de la fórmula 1.1 *y* como tiempo de cruce de la rama corta. (El notebook `experimento_doble_puente.ipynb` los tenía desacoplados en dos constantes distintas; ese es el criterio a preferir.)
> - **Fidelidad de las simulaciones estocásticas.** Tanto `experimento_doble_puente` como `montecarlo_aco` usan un esquema de *depósito al llegar* (un término), no los dos términos exactos de 1.2/1.3. Es correcto para intuición y estadística, pero la reproducción literal de 1.2/1.3 vive en `deneubourg_puente_doble.ipynb`.
> - **Reproducibilidad.** Los notebooks estocásticos no fijan semilla (`np.random.seed`); cada corrida difiere. Fijar una semilla ayuda a comparar resultados.
> - **Detalle menor.** En `montecarlo_aco.ipynb`, la etiqueta del *slider* de $\alpha$ usa `'...($\alpha$)...'` sin cadena *raw*; conviene `r'...'` para que el `\a` no se interprete como carácter de control.
> - **Verificar contra el libro.** El número "Figura 1.4" citado en `montecarlo_aco.ipynb` conviene cotejarlo con tu copia del libro.

---

## Material relacionado

- `estabilidad_puntos_fijos.md` — guía de ejercicios de estabilidad de puntos fijos (con respuestas), verificados en `deneubourg_puente_doble.ipynb`.
- Curso de Marco Dorigo (referencia externa): https://imada.sdu.dk/u/marco/Teaching/AY2016-2017/DM841/

## Referencias

Las referencias bibliográficas completas (Deneubourg et al. 1990; Goss et al. 1989; Beckers et al. 1993; Dorigo & Stützle 2004) están en el documento teórico [`modelo_estocastico_a_discreto.md`](modelo_estocastico_a_discreto.md#7-referencias).