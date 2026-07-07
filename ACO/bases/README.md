# Práctica: estabilidad de puntos fijos vía derivada

Este README acompaña la deducción del caso estacionario del modelo de Deneubourg (Dorigo & Stützle, *Ant Colony Optimization*, sección 1.1.2). Son 4 ejercicios de dificultad creciente para entrenar la misma técnica que usamos ahí, con funciones más simples.

## El criterio que vamos a aplicar

Dado un mapeo $x_{n+1} = f(x_n)$, un punto $x^*$ es **punto fijo** si $f(x^*) = x^*$.

Para clasificar su estabilidad:

- Si $|f'(x^*)| < 1$ → el punto es **estable** (atrae trayectorias cercanas)
- Si $|f'(x^*)| > 1$ → el punto es **inestable** (repele trayectorias cercanas)
- Si $|f'(x^*)| = 1$ → el criterio no concluye (caso frontera, requiere análisis de orden superior)

Intenta cada ejercicio en papel **antes** de mirar la sección de respuestas al final. El procedimiento es siempre el mismo: (1) encontrar los puntos fijos resolviendo $f(x)=x$, (2) derivar $f$, (3) evaluar la derivada en cada punto fijo, (4) clasificar.

---

## Si necesitas repasar antes de empezar

| Tema | Libro | Capítulo / sección |
|---|---|---|
| Álgebra: leyes de exponentes y factorización | James Stewart, *Cálculo: trascendentes tempranas* | Test de diagnóstico "Álgebra" al inicio del libro (antes del cap. 1) |
| Ecuaciones cuadráticas (fórmula general) | James Stewart, *Cálculo: trascendentes tempranas* | Mismo test de diagnóstico "Álgebra" |
| Límites y límites al infinito | James Stewart, *Cálculo: trascendentes tempranas* | Cap. 2, "Límites y derivadas" — sección 2.6, "Límites al infinito" |
| Regla del cociente (y del producto) | James Stewart, *Cálculo: trascendentes tempranas* | Cap. 3, "Reglas de derivación" — sección 3.2 |
| Regla de la cadena | James Stewart, *Cálculo: trascendentes tempranas* | Cap. 3, "Reglas de derivación" — sección 3.4 |
| Estabilidad de puntos fijos en mapas discretos ($x_{n+1}=f(x_n)$) | Steven H. Strogatz, *Nonlinear Dynamics and Chaos* | Cap. 10, "One-Dimensional Maps" (especialmente la sección 10.4, donde se analiza el mapa logístico con el mismo criterio de la derivada que usamos aquí) |
| Ecuaciones diferenciales con retardo (para el modelo completo de Deneubourg, ecs. 1.2-1.3) | Yang Kuang, *Delay Differential Equations: With Applications in Population Dynamics* | Cap. 1, introducción — motiva el tema con ejemplos biológicos muy similares al de las hormigas |

Nota sobre disponibilidad: el libro de Stewart es el más fácil de conseguir en español (es el texto estándar en la mayoría de universidades de la región, tu propia UdeA probablemente lo usa en los cursos de cálculo). El de Strogatz es más especializado y normalmente solo se consigue en inglés, pero el capítulo 10 es corto y muy legible incluso si el resto del libro te resulta denso. El de Kuang es ya literatura de posgrado — solo acude a él si quieres profundizar en la parte de retardo temporal, no es necesario para resolver los 4 ejercicios de este documento.

Link util: https://github.com/vaibhavp369/Mathematics_Books/tree/main

---

## Ejercicio 1 — calentamiento

Sea $f(x) = x^2$.

Encuentra todos los puntos fijos en $[0,1]$ y clasifica su estabilidad.

## Ejercicio 2 — tres puntos fijos

Sea $f(x) = x^3$.

Encuentra todos los puntos fijos (ahora en toda la recta real, no solo $[0,1]$) y clasifica cada uno.

## Ejercicio 3 — el mapa logístico

Sea $f(x) = r\,x(1-x)$, con $r=2$. Este es el mapa logístico clásico usado en dinámica de poblaciones — probablemente lo reconocerás si has visto caos determinista o bifurcaciones.

Encuentra los puntos fijos distintos de la trivialidad y clasifícalos.

## Ejercicio 4 — el puente de vuelta a las hormigas

Sea $f(p) = \dfrac{p^n}{p^n + (1-p)^n}$, para un parámetro entero $n \geq 1$ (nota: es la misma familia de funciones que usamos con $\alpha$ en el modelo de Deneubourg, solo que aquí la llamamos $n$).

1. Muestra que $p=0$, $p=1/2$ y $p=1$ son siempre puntos fijos, sin importar el valor de $n$.
2. Demuestra, derivando desde cero (regla del cociente + regla de la cadena), que $f'(1/2) = n$.
3. ¿Para qué valores de $n$ es $p=1/2$ estable? ¿Coincide con lo que esperarías biológicamente?

---
---

## Respuestas — no mires hasta intentarlo

### Ejercicio 1

**Puntos fijos:** resolver $x = x^2 \Rightarrow x^2 - x = 0 \Rightarrow x(x-1)=0 \Rightarrow x=0,\ x=1$.

**Derivada:** $f'(x) = 2x$.

**Clasificación:**
- $f'(0) = 0$, $|0|<1$ → **estable**
- $f'(1) = 2$, $|2|>1$ → **inestable**

### Ejercicio 2

**Puntos fijos:** $x = x^3 \Rightarrow x^3 - x = 0 \Rightarrow x(x^2-1) = 0 \Rightarrow x = 0,\ 1,\ -1$.

**Derivada:** $f'(x) = 3x^2$.

**Clasificación:**
- $f'(0) = 0$ → **estable**
- $f'(1) = 3$ → **inestable**
- $f'(-1) = 3$ → **inestable**

### Ejercicio 3

**Puntos fijos:** $x = 2x(1-x) \Rightarrow x\left[1-2(1-x)\right] = 0 \Rightarrow x=0$ o $1-2+2x=0 \Rightarrow x = 1/2$.

**Derivada:** $f'(x) = r(1-2x) = 2(1-2x)$ (usando regla del producto sobre $r\,x(1-x) = rx - rx^2$).

**Clasificación:**
- $f'(0) = 2(1-0) = 2$ → **inestable**
- $f'(1/2) = 2(1-1) = 0$ → **estable**

Esto coincide con el comportamiento conocido del mapa logístico para $1<r<3$: converge de forma estable al valor no trivial $(r-1)/r$.

### Ejercicio 4

**Parte 1 — puntos fijos:**
- $p=0$: numerador $=0^n=0$, denominador $=0+1=1$, entonces $f(0)=0$. ✓
- $p=1$: numerador $=1$, denominador $=1+0=1$, entonces $f(1)=1$. ✓
- $p=1/2$: numerador y denominador son simétricos, $f(1/2) = \dfrac{(1/2)^n}{(1/2)^n+(1/2)^n} = \dfrac{1}{2}$. ✓

**Parte 2 — derivada en $p=1/2$:**

Sea $g(p)=p^n$ y $h(p)=p^n+(1-p)^n$. Por la regla del cociente:

$$f'(p) = \frac{g'(p)\,h(p) - g(p)\,h'(p)}{h(p)^2}$$

con $g'(p) = n\,p^{n-1}$ y $h'(p) = n\,p^{n-1} - n(1-p)^{n-1}$ (la segunda parte por regla de la cadena, con el signo negativo típico de derivar $(1-p)^n$).

Evaluando en $p=1/2$: $g(1/2)=h(1/2)/2=(1/2)^n$, $g'(1/2)=n(1/2)^{n-1}$, y $h'(1/2)=n(1/2)^{n-1}-n(1/2)^{n-1}=0$.

$$f'(1/2) = \frac{n(1/2)^{n-1}\cdot 2(1/2)^n - (1/2)^n\cdot 0}{\left(2(1/2)^n\right)^2} = \frac{2n(1/2)^{2n-1}}{4(1/2)^{2n}} = \frac{n}{2}\cdot\frac{(1/2)^{2n-1}}{(1/2)^{2n-1}}\cdot 2= n$$

(Sigue el álgebra con cuidado — el resultado limpio $f'(1/2)=n$ es el mismo patrón exacto que obtuvimos para $\alpha$ en el modelo de las hormigas.)

**Parte 3 — interpretación:**
- $n=1$: $f'(1/2)=1$ → caso frontera, sin amplificación neta.
- $n>1$: $f'(1/2)=n>1$ → **inestable**, coincide con el comportamiento observado en la colonia real (convergencia hacia una sola rama).
- $n<1$: $f'(1/2)<1$ → **estable**, la colonia se repartiría 50/50 — régimen que no se observa biológicamente, y por eso Deneubourg y colegas ajustaron $\alpha=2$ empíricamente y no $\alpha<1$.