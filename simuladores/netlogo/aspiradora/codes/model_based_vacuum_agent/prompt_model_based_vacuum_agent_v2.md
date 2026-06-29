# Prompt: ModelBasedVacuumAgent en NetLogo

## Contexto
Estoy traduciendo los agentes del Capítulo 2 de Russell & Norvig (AIMA)
de Python a NetLogo como parte de un proyecto de robótica de enjambre
(ESP-ACO). Ya tengo implementado el `ReflexVacuumAgent` en NetLogo y
quiero implementar el siguiente agente: `ModelBasedVacuumAgent`.

## Diferencia clave respecto al agente anterior
El `ModelBasedVacuumAgent` mantiene un modelo interno del mundo.
Cuando sabe que ambas celdas están limpias, ejecuta `NoOp` en lugar
de seguir rebotando. En Python:

```python
def __init__(self, location):
    self.location = location
    self.model = {
        VacuumEnvironment.loc_A: None,
        VacuumEnvironment.loc_B: None
    }

def act(self, env):
    location, status = self.percept(env)
    self.model[location] = status

    if self.model[loc_A] == self.model[loc_B] == 'Clean':
        return 'NoOp'
    elif status == 'Dirty':
        return 'Suck'
    elif location == loc_A:
        return 'Right'
    elif location == loc_B:
        return 'Left'
```

## Modelo interno: atributo del agente, no del entorno
`self.model` pertenece a la instancia del agente, no al entorno.
En NetLogo esto se traduce con `turtles-own`, no con `globals`:

```netlogo
turtles-own [
  model-A  ; "Unknown", "Dirty" o "Clean"
  model-B  ; "Unknown", "Dirty" o "Clean"
]
```

La inicialización va dentro de `create-turtles` en `place-agent`,
no en `setup`. El acceso desde contexto observer usa:

```netlogo
ask turtle 0 [ set model-A status ]   ; escritura
let known-A [model-A] of turtle 0     ; lectura
```

## Interfaz requerida
- **Switches**: `dirty-A` y `dirty-B` (true = Dirty, false = Clean)
- **Chooser**: `initial-location` con opciones `"A"` y `"B"`
- **Botones**: `Setup`, `Go` (forever), `Step`
- **Monitores de entorno**: `Status A`, `Status B`
- **Monitores de sensor**: `Slot`, `Status Slot`
- **Monitor de actuador**: `Action`

### Semántica de los monitores
| Monitor | Variable | Valores posibles |
|---|---|---|
| Status A | `status-A` | `"Dirty"`, `"Clean"` |
| Status B | `status-B` | `"Dirty"`, `"Clean"` |
| Slot | `slot` | `"Unknown"`, `"A"`, `"B"` |
| Status Slot | `status-slot` | `"Unknown"`, `"Dirty"`, `"Clean"` |
| Action | `action-slot` | `"Unknown"`, `"Suck"`, `"Right"`, `"Left"`, `"NoOp"` |

Los monitores `Slot`, `Status Slot` y `Action` arrancan en `"Unknown"`
incluso después de `Setup` — el agente está "apagado" hasta que
ejecuta su primer ciclo.

## Globals requeridos
```netlogo
globals [
  status-A    ; estado real celda A
  status-B    ; estado real celda B
  slot        ; celda donde está el agente
  status-slot ; estado de la celda actual percibida
  action-slot ; última acción ejecutada
]
```

## Colores del entorno
- Celda Dirty: `brown + 3`
- Celda Clean: `cyan`
- Bordes: `black`
- Agente: tortuga roja con forma `"car"`, tamaño 3

## Dimensiones del mundo
- `min-pxcor = -10`, `max-pxcor = 10`
- `min-pycor = -5`, `max-pycor = 5`
- Celda A: `pxcor >= -9 and pxcor < 0`
- Celda B: `pxcor >= 0 and pxcor <= 9`
- Divisor central: `pxcor = 0`

## Restricciones técnicas obligatorias
- Todo el ciclo percepción-decisión-acción corre en contexto
  **observer**, no en contexto de tortuga, para evitar errores
  con `tick` y `ask patches`.
- La posición del agente se lee con `[pxcor] of turtle 0`.
- `model-A` y `model-B` son `turtles-own`, inicializados en
  `"Unknown"` dentro de `create-turtles` en `place-agent`.
- La actualización del modelo usa `ask turtle 0 [...]` y la
  lectura usa `[model-A] of turtle 0`.
- `slot`, `status-slot` y `action-slot` se asignan en cada ciclo
  de `step-once` antes del `tick`.
- `action-slot` se asigna en **todos** los ramales de decisión,
  incluyendo `"NoOp"`, antes del `tick` o `stop`.
- Redibujar bordes después de cada `Suck`.
- Incluir `wait 0.5` en `step-once` para visualizar la secuencia.
- El `stop` del `NoOp` detiene `step-once`; el `tick` va antes del `stop`.

## Estructura de step-once
```
1. PERCEPCIÓN
   - leer agent-x, derivar location y status
   - set slot = location
   - set status-slot = status

2. ACTUALIZACIÓN DEL MODELO INTERNO
   - ask turtle 0 [ set model-A/B status ]
   - let known-A/B = [model-A/B] of turtle 0

3. DECISIÓN Y ACCIÓN (por prioridad)
   - known-A = "Clean" AND known-B = "Clean"
     → set action-slot "NoOp" | tick | stop
   - status = "Dirty"
     → Suck + set action-slot "Suck" + redibuja
   - location = "A"
     → Right + set action-slot "Right"
   - location = "B"
     → Left  + set action-slot "Left"
   - tick (rama no-NoOp)

4. wait 0.5
```

## Documentación requerida por procedimiento
Cada procedimiento debe incluir:
- Descripción
- Analogía Python
- Analogía ESP32

## Formato de entrega
- Archivo `.nlogox` (NetLogo 7.0.4) completo y válido
- Incluir bloque `turtleShapes` y `linkShapes` estándar de NetLogo 7
- `previewCommands`: `setup repeat 75 [ go ]`
