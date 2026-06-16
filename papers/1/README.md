# Estigmergia, Auto-organización y Sorting — Conceptos Clave
**Fuente:** Holland & Melhuish (1999), *Stigmergy, self-organisation, and sorting in collective robotics*

---

## 1. Definición de estigmergia

Concepto introducido por **Grassé (1959)** para explicar el comportamiento constructor de las termitas.

> [!QUOTE]
> *"La coordinación de tareas y la regulación de las construcciones no depende directamente de los obreros, sino de las construcciones mismas. El obrero no dirige su trabajo, sino que es guiado por él."*
> — Grassé, 1959

> [!TIP]
> **Definición operacional:** Estigmergia es la influencia sobre el comportamiento de un agente que ejercen los **efectos persistentes en el entorno** producidos por comportamientos previos. El entorno acumula "memoria" de las acciones pasadas, y esa memoria guía las acciones futuras — sin coordinación directa entre agentes.

El ciclo fundamental es:

```mermaid
flowchart LR
    A([Agente actúa\nsobre el entorno]) --> B([Entorno cambia\npersistentemente])
    B --> C([Cambio es percibido\npor otro agente])
    C --> D([Nuevo agente\nmodifica su comportamiento])
    D --> A
    style A fill:#4A90D9,color:#fff
    style B fill:#E8A838,color:#fff
    style C fill:#4A90D9,color:#fff
    style D fill:#E8A838,color:#fff
```

> [!IMPORTANT]
> No hay comunicación directa agente→agente. El entorno es el único canal. Esto es lo que distingue la estigmergia de la coordinación explícita.

---

## 2. Taxonomía: estigmergia activa vs. pasiva

Holland & Melhuish refinan el concepto identificando **tres mecanismos** por los que el entorno modificado puede afectar el comportamiento posterior:

```mermaid
flowchart TD
    ROOT["Estigmergia\n(efecto de acciones pasadas)"]
    ROOT --> ACTIVA["🟢 ACTIVA\nAfecta al agente mismo"]
    ROOT --> PASIVA["🟠 PASIVA\nAfecta solo el resultado"]

    ACTIVA --> I["(i) Efecto cualitativo\nCambia la ELECCIÓN de acción"]
    ACTIVA --> II["(ii) Efecto cuantitativo\nCambia los PARÁMETROS de la acción"]
    PASIVA --> III["(iii) Efecto sobre el resultado\nLa acción es la misma,\nel outcome es distinto"]

    style ROOT fill:#2C3E50,color:#fff
    style ACTIVA fill:#27AE60,color:#fff
    style PASIVA fill:#E67E22,color:#fff
    style I fill:#A9DFBF,color:#222
    style II fill:#A9DFBF,color:#222
    style III fill:#FAD7A0,color:#222
```

### (i) Efecto cualitativo → estigmergia activa
Una acción previa **cambia la elección de acción** del agente siguiente. El agente hace algo *distinto* de lo que habría hecho sin esa señal ambiental. Captura el sentido original de Grassé: la acción es guiada por el entorno.

### (ii) Efecto cuantitativo → estigmergia activa
La acción elegida no cambia, pero sí sus **parámetros**: posición, intensidad, frecuencia, duración, latencia. El agente hace lo mismo pero de forma diferente.

### (iii) Efecto sobre el resultado → estigmergia pasiva
La acción previa no cambia ni la elección ni los parámetros, pero sí el **resultado físico**. El agente intenta hacer X, pero el entorno modificado produce Y.

> [!NOTE]
> **Ejemplo canónico de estigmergia pasiva:** un coche en un camino de barro. El conductor decide su trayectoria independientemente, pero las roderas de conductores anteriores desvían físicamente el resultado. Las acciones pasadas afectan el *outcome* sin tocar la decisión.

> [!TIP]
> La estigmergia pasiva se aproxima a fenómenos puramente físicos — dunas de arena, deltas de ríos, meandros — donde una fuerza constante modifica el entorno. La estigmergia **activa** añade agentes móviles con capacidad de sensar y actuar, amplificando exponencialmente el rango de estructuras posibles.

---

## 3. Estigmergia y auto-organización

La estigmergia es el **mecanismo**; la auto-organización (SO) es el **proceso emergente** que resulta de aplicarlo iterativamente.

> [!IMPORTANT]
> **Definición de SO** (Bonabeau et al., citado en el paper): *"Un conjunto de mecanismos dinámicos donde las estructuras aparecen a nivel global a partir de interacciones entre componentes de nivel inferior. Las reglas se ejecutan sobre información puramente local, sin referencia al patrón global."*

```mermaid
flowchart LR
    subgraph INGREDIENTES["🧪 Ingredientes de la SO"]
        direction TB
        I1["Retroalimentación\npositiva"]
        I2["Retroalimentación\nnegativa"]
        I3["Amplificación de\nfluctuaciones"]
        I4["Múltiples\ninteracciones"]
    end

    subgraph FIRMAS["🔍 Firmas características"]
        direction TB
        F1["Estructuras espacio-temporales\nen medio homogéneo"]
        F2["Multiestabilidad\n(múltiples estados estables)"]
        F3["Bifurcaciones paramétricas\n(cambio cualitativo en umbral)"]
    end

    INGREDIENTES -->|"proceso iterativo\nvía estigmergia"| FIRMAS

    style INGREDIENTES fill:#EBF5FB,color:#222
    style FIRMAS fill:#FEF9E7,color:#222
    style F3 fill:#FADBD8,color:#222
```

> [!WARNING]
> **Bifurcación paramétrica:** pequeños cambios en un parámetro del sistema pueden producir cambios *cualitativos* en el resultado — no graduales sino abruptos. El Experimento 3 del paper lo demuestra empíricamente: con p=0.88 el sistema produce indistintamente clústeres centrales o periféricos, dos atractores completamente distintos.

---

## 4. El experimento fundacional: las termitas de Grassé

Grassé observó termitas construyendo estructuras complejas sin ningún plano central ni líder. La clave: **la construcción misma dirige a los constructores**.

```mermaid
sequenceDiagram
    participant T1 as Termita A
    participant E as Entorno (construcción)
    participant T2 as Termita B
    participant T3 as Termita C

    T1->>E: Deposita material en sitio X
    Note over E: Configuración cambia
    E-->>T2: Nueva configuración estimula depósito en Y
    T2->>E: Deposita material en Y
    Note over E: Configuración cambia de nuevo
    E-->>T3: Estimula depósito en Z
    T3->>E: Deposita material en Z
    Note over E: Estructura compleja emerge
    Note over T1,T3: Ninguna termita conoce el plan global
```

> [!TIP]
> **Lo que hace poderoso este mecanismo:**
> - No requiere coordinación directa entre agentes
> - No requiere estado interno que conecte sub-tareas secuenciales
> - La secuencia completa puede ejecutarse con **agentes distintos para cada paso**
> - La tasa de ejecución en cada ubicación es función del número de agentes presentes → el entorno **distribuye la fuerza de trabajo automáticamente**

---

## 5. Demostración robótica: complejidad de reglas triviales

Holland & Melhuish demuestran que el **sorting de dos tipos de objetos** emerge de agentes con capacidades mínimas, construyendo sobre Beckers et al. (1994).

> [!IMPORTANT]
> La asimetría entre lo que los robots **tienen** y lo que **no tienen** es el argumento central del paper.

| ✅ Robots SÍ tienen | ❌ Robots NO tienen |
|---|---|
| Detectar si empujan un objeto | Memoria |
| Detectar el color del objeto en el gripper | Orientación espacial |
| Detectar obstáculos por IR | Comunicación entre robots |
| Moverse en línea recta y girar aleatoriamente | Conocimiento de densidad local |
| | Modelo del estado global |

### El algoritmo pullback

```mermaid
flowchart TD
    START([Robot en movimiento]) --> Q1{¿Gripper\npresionado?}

    Q1 -->|No| Q2{¿Objeto\nadelante detectado\npor IR?}
    Q2 -->|No| FORWARD[Avanza recto\nRegla 3]
    Q2 -->|Sí| FORWARD

    Q1 -->|Sí| Q3{¿Objeto\nadelante?}

    Q3 -->|Sí — colisión con obstáculo| TURN["Giro aleatorio\nalejándose\nRegla 1"]
    TURN --> FORWARD

    Q3 -->|No — lleva frisbee solo| Q4{¿Qué tipo\nde frisbee\ncarga?}

    Q4 -->|ANILLO| DROP_R["Deposita aquí\n(punto de choque)\nRetrocede poco\nGiro aleatorio\nRegla 2"]
    Q4 -->|PLANO| PULLBACK["Baja pin de retención\nRetrocede DISTANCIA PULLBACK\nSube pin\nDeposita plano\nRetrocede poco\nGiro aleatorio\nRegla 2"]

    DROP_R --> FORWARD
    PULLBACK --> FORWARD

    style START fill:#2C3E50,color:#fff
    style FORWARD fill:#27AE60,color:#fff
    style DROP_R fill:#3498DB,color:#fff
    style PULLBACK fill:#E67E22,color:#fff
    style TURN fill:#95A5A6,color:#fff
```

### Por qué emerge el sorting anular

```mermaid
flowchart LR
    subgraph ROBOT["Robot se aproxima al clúster"]
        direction TB
        R1["Trayectoria aleatoria\nsiempre desde FUERA\n→ componente hacia el centro"]
    end

    subgraph ANILLO["Si carga ANILLO"]
        direction TB
        A1["Choca con frisbee\nen el clúster"]
        A2["Deposita en punto\nde choque"]
        A3["Queda CERCA\ndel centro ⬤"]
        A1 --> A2 --> A3
    end

    subgraph PLANO["Si carga PLANO"]
        direction TB
        P1["Choca con frisbee\nen el clúster"]
        P2["Retrocede distancia\nde pullback"]
        P3["Deposita FUERA\ndel clúster ○"]
        P1 --> P2 --> P3
    end

    ROBOT --> ANILLO
    ROBOT --> PLANO

    style ROBOT fill:#2C3E50,color:#fff
    style ANILLO fill:#2980B9,color:#fff
    style PLANO fill:#D35400,color:#fff
```

> [!NOTE]
> El sorting **no requiere** que los anillos sean físicamente más pequeños o que puedan penetrar en espacios inaccesibles a los planos. Ambos tipos llegan igual de cerca al centro. La diferencia es exclusivamente de **destino final**: los anillos se quedan donde llegan; los planos son expulsados hacia afuera.

> [!WARNING]
> **Alta varianza temporal:** en 5 réplicas, el tiempo de convergencia varió entre 2h 45m y 25h 20m — casi un orden de magnitud. Esto es una firma de los sistemas estigmérgicos con múltiples atractores: el tiempo depende de qué clústeres intermedios se forman por azar. No interpretar varianza alta como inestabilidad del mecanismo.

---

## 6. Por qué los robots físicos revelan más que las simulaciones abstractas

> [!TIP]
> **Principio central:** la estigmergia es una *explotación de la física mediante el comportamiento*. A física más rica, más simple puede ser el comportamiento.

Las simulaciones de grilla tienen dos desventajas severas frente a los robots físicos:

1. **Skating sobre sensing y actuación:** en el grid, los objetos se "conocen" directamente y las acciones tienen efectos precisos e invariantes. En el mundo real, ambas cosas son ruidosas y variables.
2. **Física empobrecida:** la geometría del movimiento en línea recta, la forma de los objetos, el radio de colisión — todo esto es parte del mecanismo estigmérgico, no ruido a eliminar.

> [!IMPORTANT]
> El Experimento 4 demostró que el mismo resultado emergente puede obtenerse ajustando un parámetro **computacional** (probabilidad p en el algoritmo) *o* un parámetro **físico** del sensor (ángulo de aceptación del IR). Esto revela que la evolución tiene **múltiples puntos de acceso** para modular un comportamiento estigmérgico — no solo el "software" del agente.

```mermaid
flowchart LR
    subgraph SIM["Simulación de grilla"]
        direction TB
        S1["Sensing perfecto"]
        S2["Actuación precisa"]
        S3["Física simplificada"]
        S4["Soluciones más complejas\nnecesarias"]
    end

    subgraph ROBOT["Robots físicos"]
        direction TB
        R1["Sensing ruidoso"]
        R2["Actuación variable"]
        R3["Física completa"]
        R4["Soluciones más simples\nposibles"]
    end

    SIM -.->|"pierde oportunidades\nque da la física"| ROBOT

    style SIM fill:#FADBD8,color:#222
    style ROBOT fill:#D5F5E3,color:#222
    style S4 fill:#E74C3C,color:#fff
    style R4 fill:#27AE60,color:#fff
```

---

*Referencia completa: Holland, O. & Melhuish, C. (1999). Stigmergy, self-organisation, and sorting in collective robotics. Artificial Life.*