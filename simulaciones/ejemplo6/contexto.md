# Contexto del proyecto

Estoy trabajando en un ejercicio de agentes AIMA (Russell & Norvig, Cap. 2) sobre un
mundo lineal de N celdas en NetLogo. Ya completé dos fases:

- Fase 1: agente basado en modelo en un único proceso Python (entorno + agente juntos).
- Fase 2: agente separado del mundo, comunicado con NetLogo por puerto serial virtual
  (protocolo sincrono de pregunta-respuesta), documentada por completo en el README
  adjunto.

# Objetivo de esta sesión

Migrar la Fase 2 a la Fase 3: reemplazar el script `agente.py` (que corre en un proceso
Python aparte) por una implementación equivalente en firmware C++ corriendo en un ESP32
físico. La interfaz de NetLogo debe permanecer exactamente igual en su comportamiento
observable; solo cambia qué hay del otro lado del puerto serial.

# Restricción de forma de trabajo (importante)

- Avancemos de forma gradual, paso a paso, como en pair programming: me explicas un
  bloque pequeño de código a la vez, con el razonamiento detrás de cada decisión, y
  esperas mi confirmación antes de continuar al siguiente paso.
- Aplico los cambios yo mismo en mi máquina; no reemplaces archivos completos de una
  sola vez.
- Antes de escribir código, quiero resolver primero una decisión de diseño: si el
  esquema de comunicación puede seguir siendo síncrono (pregunta-respuesta) en el
  ESP32, o si es necesario adoptar el patrón asíncrono (`Serial.available()` no
  bloqueante + `millis()`) que ya usamos en un ejemplo anterior de potenciómetro/LED.
- No introduzcas nada relacionado con ACO, feromona, o múltiples agentes en esta
  sesión — esa es una rama de trabajo deliberadamente separada de este ejercicio.

# Archivos que voy a adjuntar para dar contexto completo

1. `fase2_agente_serial.md` — documentación completa de la Fase 2 (motivación,
   diseño en dos capas, protocolo de mensajes, resultados y próximos pasos).
2. `agente_base.py` — el programa de agente puro (Capa 1), sin nada de serial.
3. `agente.py` — la Capa 1 envuelta con la comunicación serial (Capa 2 actual, en Python).
4. `mundo2.nlogox` — el mundo y la interfaz de NetLogo, ya funcional con la Fase 2.
5. `main.cpp` y `platformio.ini` — el firmware de referencia del ejemplo anterior
   (potenciómetro/LED), que ya resolvió el problema de comunicación serial ESP32↔NetLogo
   y sirve de plantilla para la arquitectura de E/S en C++.

# Primer paso esperado de tu parte

Antes de proponer código, confirma que entendiste el estado actual (resume brevemente
qué hace cada archivo) y abre la discusión sobre la decisión de diseño síncrono vs.
asíncrono, presentando ventajas/desventajas de cada una para este caso específico,
antes de que yo decida cuál seguir.