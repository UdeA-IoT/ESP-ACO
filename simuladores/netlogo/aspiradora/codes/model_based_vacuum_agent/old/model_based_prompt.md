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
model = {loc_A: None, loc_B: None}

def program(percept):
    location, status = percept
    model[location] = status
    if model[loc_A] == model[loc_B] == 'Clean':
        return 'NoOp'
    elif status == 'Dirty':
        return 'Suck'
    elif location == loc_A:
        return 'Right'
    elif location == loc_B:
        return 'Left'
```

## Interfaz requerida (misma que el agente anterior)
- **Switches**: `dirty-A` y `dirty-B` (true = Dirty, false = Clean)
- **Chooser**: `initial-location` con opciones `"A"` y `"B"`
- **Monitors**: `Status A` y `Status B`
- **Botones**: `Setup`, `Go` (forever), `Step`

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
- Todo el ciclo percepcion-decision-accion debe correr en contexto 
  **observer**, no en contexto de tortuga, para evitar errores de 
  contexto con `tick` y `ask patches`.
- La posicion del agente se lee con `[pxcor] of turtle 0` desde observer.
- El modelo interno se implementa como dos variables globales: 
  `model-A` y `model-B`, inicializadas en `"Unknown"`.
- Cuando `model-A = "Clean"` y `model-B = "Clean"` el agente ejecuta 
  `NoOp` y la simulacion se detiene.
- Incluir `wait 0.5` en `step-once` para visualizar la secuencia.
- Redibujar bordes despues de cada `Suck`.

## Entregable
Codigo NetLogo completo y documentado en un solo bloque, listo para 
pegar en el editor. La documentacion debe incluir para cada procedimiento:
- Descripcion
- Analogia Python
- Analogia ESP32

## Comportamiento esperado
1. Agente inicia en la celda indicada por `initial-location`
2. Si la celda actual esta sucia: limpia y actualiza modelo interno
3. Si la celda actual esta limpia: se mueve a la otra celda
4. Cuando el modelo interno registra ambas celdas como limpias: `NoOp` 
   y stop
5. Los monitores `Status A` y `Status B` deben reflejar el estado 
   en tiempo real