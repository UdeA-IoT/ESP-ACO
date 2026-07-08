
# Análisis Matemático y Conceptual: De Hormigas Reales a Artificiales (Secciones 1.2 y 1.3)

Este documento detalla la transición del modelo biológico observado en el experimento del puente doble hacia algoritmos de optimización distribuida.

## 1. Hacia las Hormigas Artificiales (Sección 1.2)
El primer paso consiste en transformar el comportamiento estocástico continuo de las hormigas en un modelo de **tiempo discreto** sobre un grafo de construcción.

### Expresión Matemática: Regla de Decisión Discreta
Para un grafo que modela el puente doble (nodos 1 y 2), la probabilidad $p_{is}(t)$ de que una hormiga en el nodo $i$ elija el **camino corto** ($s$) en el paso de tiempo $t$ se define como:

$$p_{is}(t) = \frac{[\tau_{is}(t)]^\alpha}{[\tau_{is}(t)]^\alpha + [\tau_{il}(t)]^\alpha} \quad$$

*   **Conexión Conceptual:** A diferencia del modelo biológico que incluye un retraso físico ($t_s$), este modelo simplifica la decisión basándose puramente en el rastro de feromona acumulada ($\tau$). El parámetro **$\alpha$** sigue siendo crucial para la **autocatálisis**, permitiendo que pequeñas diferencias iniciales se amplifiquen exponencialmente.

### Dinámica de Actualización del Rastro
La feromona en el camino corto se actualiza sumando el tráfico de hormigas que llegan desde ambos nodos del puente:
$$\tau_{is}(t) = \tau_{is}(t-1) + p_{is}(t-1)m_i(t-1) + p_{js}(t-1)m_j(t-1) \quad$$
*(Donde $m_i(t)$ es el número de hormigas en el nodo $i$ en el tiempo $t$)*.

---

## 2. Hormigas Artificiales en Grafos Genéricos (Sección 1.3)
Al pasar de un simple puente a un grafo complejo $G = (N, A)$, surgen desafíos técnicos como los **bucles** y la necesidad de una **memoria** para los agentes.

### El Problema de los Bucles y la Regla de Vecindad
Para evitar que las hormigas regresen inmediatamente por donde vinieron, se define una vecindad factible $N_i^k$ que excluye el nodo predecesor. La probabilidad de movimiento es:

$$p_{ij}^k = \begin{cases} \frac{\tau_{ij}}{\sum_{l \in N_i^k} \tau_{il}} & \text{si } j \in N_i^k \\ 0 & \text{si } j \notin N_i^k \end{cases} \quad$$

*   **Conexión Conceptual:** El uso de una **memoria local ($M^k$)** permite a la hormiga $k$ recordar los nodos visitados. Esto es esencial para la **eliminación de bucles** antes del viaje de regreso (*backward*), asegurando que solo se refuerce el camino de costo mínimo que conecta origen y destino.

---

## 3. El Algoritmo Simple-ACO (S-ACO)
El algoritmo S-ACO formaliza la actualización de feromonas mediante dos procesos críticos: **refuerzo** y **evaporación**.

### Actualización de Feromona (Refuerzo)
Durante el modo *backward*, la hormiga $k$ deposita una cantidad $\Delta \tau^k$ en los arcos $(i, j)$ visitados:
$$\tau_{ij} \leftarrow \tau_{ij} + \Delta \tau^k \quad$$

*   **Conexión Conceptual:** Para acelerar la convergencia, $\Delta \tau^k$ suele ser una función de la **calidad de la solución** ($1/L_k$), donde $L_k$ es la longitud del camino. Esto imita a especies como *Lasius niger*, que depositan más feromona al regresar de fuentes de alimento ricas.

### La Regla de Evaporación (El mecanismo de "olvido")
A diferencia de las hormigas reales donde la evaporación es lenta y a veces despreciable, en ACO es vital para la exploración. Se aplica a todos los arcos al final de cada iteración:
$$\tau_{ij} \leftarrow (1 - \rho)\tau_{ij} \quad$$

*   **Conexión Conceptual:** El parámetro **$\rho \in (0, 1]$** representa la tasa de evaporación. Matemáticamente, esto provoca una **disminución exponencial** del rastro en caminos no utilizados. Sin este factor ($\rho=0$), el sistema se volvería rígido y quedaría atrapado permanentemente en la primera solución encontrada, impidiendo el descubrimiento de rutas óptimas en problemas complejos.

---
**Resumen de la Estigmergia Matemática:** La inteligencia colectiva emerge de la interacción entre la **probabilidad de elección** (explotación) y la **evaporación** (exploración), coordinada a través de la modificación del entorno químico (feromona).


