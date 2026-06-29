# Agente Reactivo Simple — Mundo de la Aspiradora

Implementación del agente más simple descrito en el Capítulo 2 del libro
*Artificial Intelligence: A Modern Approach* (AIMA) de Russell & Norvig.
Incluye una versión standalone en Python y su equivalente en NetLogo 7.

---

## 1. Conexión con la teoría

### Tipos de agentes en AIMA

El Capítulo 2 del AIMA presenta una jerarquía de agentes inteligentes
ordenados por complejidad creciente:

| Tipo de agente | Usa estado interno | Usa modelo del mundo | Tiene metas | Tiene utilidad |
|---|:---:|:---:|:---:|:---:|
| **Simple reflex**     | No  | No  | No  | No  |
| Model-based reflex    | Sí  | Sí  | No  | No  |
| Goal-based            | Sí  | Sí  | Sí  | No  |
| Utility-based         | Sí  | Sí  | Sí  | Sí  |

Este ejemplo implementa el nivel más básico: el **agente reactivo simple**
(*simple reflex agent*).

### El agente reactivo simple

Un agente reactivo simple selecciona su acción basándose **únicamente en la
percepción actual**, sin memoria de estados anteriores. Su lógica completa
se reduce a una tabla de reglas condición-acción:

```
REFLEX-VACUUM-AGENT([location, status])   ← Fig. 2.8, AIMA
  if status = Dirty  then return Suck
  if location = A    then return Right
  if location = B    then return Left
```

El entorno es el **mundo de la aspiradora**: dos celdas contiguas (A y B),
cada una puede estar sucia (*Dirty*) o limpia (*Clean*). El agente ocupa
exactamente una celda por turno.

```
┌─────────┬─────────┐
│  Celda A│  Celda B│
│ (0, 0)  │ (1, 0)  │
└─────────┴─────────┘
```

### Limitación inherente

Cuando ambas celdas están limpias el agente **oscila indefinidamente** entre
A y B porque no tiene memoria para saber que ya terminó. Esta limitación
motiva el siguiente nivel de la jerarquía: el agente basado en modelo
(`model_based_vacuum_agent`), que mantiene un estado interno para recordar
qué celdas ya limpió.

---

## 2. Archivos

```
reflex_vacuum_agent/
├── reflex_vacuum_agent.py      # Implementación standalone en Python
└── reflex_vacuum_agent.nlogox  # Simulación equivalente en NetLogo 7
```

### `reflex_vacuum_agent.py`

Contiene dos clases:

| Clase | Responsabilidad | Equivalente AIMA |
|---|---|---|
| `VacuumEnvironment` | Define el entorno de dos celdas | Environment (Fig. 2.1) |
| `ReflexVacuumAgent` | Implementa las reglas condición-acción | Agent (Fig. 2.8) |

Métodos clave:

| Método | Qué hace |
|---|---|
| `VacuumEnvironment.get_percept(location)` | Retorna `(location, status)` de la celda actual |
| `VacuumEnvironment.execute_action(location, action)` | Aplica `Suck`, `Right` o `Left` y retorna la nueva posición |
| `ReflexVacuumAgent.act(env)` | Aplica la tabla condición-acción y ejecuta la acción |
| `ReflexVacuumAgent.run(env, steps)` | Ciclo percepción-acción por `steps` pasos |

### `reflex_vacuum_agent.nlogox`

Simulación visual en NetLogo 7.0.4. Los switches `dirty-A` y `dirty-B` de
la interfaz permiten configurar el estado inicial del entorno antes de
ejecutar la simulación.

### Mapeo de conceptos entre implementaciones

| Concepto AIMA | Python | NetLogo |
|---|---|---|
| Entorno | `VacuumEnvironment` | `globals` + `patches` |
| Estado del entorno | `self.status` dict | `status-A`, `status-B` |
| Agente | `ReflexVacuumAgent` | `turtle 0` |
| Percepción | `get_percept()` | `pxcor` + `status-A/B` |
| Reglas condición-acción | `act()` | `step-once` |
| Ciclo principal | `run()` | `go` (forever) |
| Condición de parada | `is_done()` | condición manual en interfaz |

---

## 3. Ejecución

### Python

**Requisitos:** Python 3.7 o superior. No requiere librerías externas.

**Ejecutar con el estado inicial por defecto:**

```bash
python reflex_vacuum_agent.py
```

El bloque `__main__` configura el entorno con `status_A='Dirty'`,
`status_B='Clean'` y el agente parte desde la celda A `(0, 0)`.

**Modificar el estado inicial** editando el bloque `__main__` al final del
archivo:

```python
# Ambas celdas sucias, agente inicia en B
env   = VacuumEnvironment(status_A='Dirty', status_B='Dirty')
agent = ReflexVacuumAgent(location=(1, 0))
agent.run(env, steps=8)
```

Valores válidos para `status_A` / `status_B`: `'Dirty'` o `'Clean'`.  
Valores válidos para `location`: `(0, 0)` (celda A) o `(1, 0)` (celda B).

### NetLogo

**Requisitos:** [NetLogo 7.0.4](https://ccl.northwestern.edu/netlogo/)

1. Abrir `reflex_vacuum_agent.nlogox` desde **File → Open**.
2. En la interfaz, activar o desactivar los switches `dirty-A` y `dirty-B`
   para definir el estado inicial de cada celda.
3. Presionar **Setup** para inicializar el entorno y ubicar al agente.
4. Presionar **Go** para iniciar la simulación continua, o **Step** para
   avanzar un ciclo a la vez.

---

## 4. Resultados esperados

### Configuración por defecto

```
status_A = 'Dirty'   status_B = 'Clean'   posición inicial = A (0,0)
```

### Salida del script Python

```
<Agent> perceives ((0, 0), 'Dirty') and does Suck
<Agent> perceives ((0, 0), 'Clean') and does Right
<Agent> perceives ((1, 0), 'Clean') and does Left
<Agent> perceives ((0, 0), 'Clean') and does Right
<Agent> perceives ((1, 0), 'Clean') and does Left
```

### Traza anotada

| Paso | Percepción | Regla disparada | Acción | Estado del entorno |
|:---:|---|---|---|---|
| 1 | A, Dirty | `if status = Dirty → Suck` | **Suck** | A=Clean, B=Clean |
| 2 | A, Clean | `if location = A → Right` | **Right** | A=Clean, B=Clean |
| 3 | B, Clean | `if location = B → Left`  | **Left**  | A=Clean, B=Clean |
| 4 | A, Clean | `if location = A → Right` | **Right** | A=Clean, B=Clean |
| 5 | B, Clean | `if location = B → Left`  | **Left**  | A=Clean, B=Clean |

**Observación:** a partir del paso 2 el entorno ya está completamente limpio,
pero el agente continúa oscilando entre A y B. Esto ocurre porque no tiene
memoria del estado anterior: cada decisión se toma solo con la percepción
del momento presente. Es el comportamiento esperado y correcto para un
agente reactivo simple.
