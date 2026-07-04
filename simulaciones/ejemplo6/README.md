# Agente


```cpp
#include <Arduino.h>

#define DEBUG_MODE 1  // 1 = mensajes de debug activos (Wokwi) | 0 = protocolo limpio (NetLogo)

#if DEBUG_MODE
  #define DEBUG_PRINT(x)   Serial.print(x)
  #define DEBUG_PRINTLN(x) Serial.println(x)
#else
  #define DEBUG_PRINT(x)
  #define DEBUG_PRINTLN(x)
#endif

enum class AgentState {
  BOOT,
  WAITING_SETUP,
  RUNNING,
  FINISH
};

AgentState agentState;
volatile bool resetPending = false; // se pone en true desde el ISR, se consume en loop()

volatile unsigned long ultimoResetMillis = 0;
const unsigned long DEBOUNCE_MS = 200;

unsigned long ultimoParpadeoMillis = 0;
bool ledEncendido = false;


// Variables del modelo del agente (equivalente a self.n_celdas / self.model /
// self.performance en agente_base.py). Basura hasta que llega el Setup real.
int nCeldas = 0;
int modelo = 0;
int performance = 0;

// Pines físicos
const int LED_PIN = 2;              // LED de estado (heredado de main.cpp de referencia)
const int RESET_BUTTON_PIN = 4;     // Botón de reset lógico, con pull-up interno (a GND)

String rxBuffer = "";

// Lectura no bloqueante por línea, equivalente en propósito al rx_buffer
// persistente ya usado del lado de Python (ver README, sección 5.1).
// Retorna true solo cuando se completó una línea (encontró '\n').
bool leerLineaSerial(String &lineaCompleta) {
  while (Serial.available() > 0) {
    char c = Serial.read();
    if (c == '\n') {
      lineaCompleta = rxBuffer;
      rxBuffer = "";
      return true;
    } else if (c != '\r') {
      rxBuffer += c;
    }
  }
  return false;
}

void resetButtonInterruptHandler() {
  unsigned long ahora = millis();
  if (ahora - ultimoResetMillis < DEBOUNCE_MS) {
    return; // rebote descartado, no es una presión nueva
  }
  ultimoResetMillis = ahora;

  agentState = AgentState::WAITING_SETUP;
  performance = 0;
  resetPending = true;
}

void handleBootState() {
  DEBUG_PRINTLN("[DEBUG] BOOT -> WAITING_SETUP");
  agentState = AgentState::WAITING_SETUP;
}

void handleWaitingSetupState() {
  String linea;
  if (leerLineaSerial(linea)) {
    int comaPos = linea.indexOf(',');

    if (comaPos <= 0) {
      DEBUG_PRINT("[DEBUG] Setup invalido, formato incorrecto: '");
      DEBUG_PRINT(linea);
      DEBUG_PRINTLN("'");
      return;
    }

    String nCeldasStr = linea.substring(0, comaPos);
    String celdaInicialStr = linea.substring(comaPos + 1);

    if (nCeldasStr.length() == 0 || celdaInicialStr.length() == 0) {
      DEBUG_PRINTLN("[DEBUG] Setup invalido, falta N o celda_inicial");
      return;
    }

    int nCeldasCandidato = nCeldasStr.toInt();
    if (nCeldasCandidato <= 0) {
      DEBUG_PRINT("[DEBUG] Setup invalido, N debe ser positivo, recibido: ");
      DEBUG_PRINTLN(nCeldasCandidato);
      return;
    }

    nCeldas = nCeldasCandidato;
    modelo = celdaInicialStr.toInt();
    performance = 0;
    agentState = AgentState::RUNNING;

    DEBUG_PRINTLN("[DEBUG] WAITING_SETUP -> RUNNING");
    DEBUG_PRINT("[DEBUG] nCeldas="); DEBUG_PRINTLN(nCeldas);
    DEBUG_PRINT("[DEBUG] modelo=");  DEBUG_PRINTLN(modelo);
  }
}

void handleRunningState() {
  String linea;
  if (!leerLineaSerial(linea)) {
    return;
  }

  if (linea == "EXIT") {
    DEBUG_PRINTLN("[DEBUG] RUNNING -> FINISH (EXIT recibido)");
    agentState = AgentState::FINISH;
    return;
  }

  bool esNumerica = linea.length() > 0;
  for (unsigned int i = 0; i < linea.length(); i++) {
    char c = linea.charAt(i);
    if (!isDigit(c) && !(i == 0 && c == '-')) {
      esNumerica = false;
      break;
    }
  }

  if (!esNumerica) {
    DEBUG_PRINT("[DEBUG] percepto invalido, no numerico: '");
    DEBUG_PRINT(linea);
    DEBUG_PRINTLN("'");
    return;
  }

  int percepto = linea.toInt();

  if (percepto < 0 || percepto >= nCeldas) {
    DEBUG_PRINT("[DEBUG] percepto fuera de rango: ");
    DEBUG_PRINT(percepto);
    DEBUG_PRINT(" (nCeldas="); DEBUG_PRINT(nCeldas); DEBUG_PRINTLN(")");
    return;
  }

  if (modelo != percepto) {
    DEBUG_PRINT("[DEBUG] desincronizacion: modelo="); DEBUG_PRINT(modelo);
    DEBUG_PRINT(" percepto="); DEBUG_PRINTLN(percepto);
    modelo = percepto;
  }

  int prediccion = (modelo + 1) % nCeldas;
  if (prediccion == 0) {
    performance++;
    DEBUG_PRINT("[DEBUG] vuelta completa, performance="); DEBUG_PRINTLN(performance);
  }
  modelo = prediccion;

  DEBUG_PRINT("[DEBUG] percepto="); DEBUG_PRINT(percepto);
  DEBUG_PRINT(" -> modelo="); DEBUG_PRINTLN(modelo);

  Serial.println('A');
}

void handleFinishState() {
  // Estado terminal real: no hace nada, no lee Serial, no transiciona
  // por sí solo. La única salida es el botón de reset (interrupción).
}


void actualizarLed() {
  unsigned long ahora = millis();

  switch (agentState) {
    case AgentState::BOOT:
      digitalWrite(LED_PIN, LOW);
      break;

    case AgentState::WAITING_SETUP:
      if (ahora - ultimoParpadeoMillis >= 500) { // parpadeo lento
        ledEncendido = !ledEncendido;
        digitalWrite(LED_PIN, ledEncendido);
        ultimoParpadeoMillis = ahora;
      }
      break;

    case AgentState::RUNNING:
      digitalWrite(LED_PIN, HIGH);
      break;

    case AgentState::FINISH:
      if (ahora - ultimoParpadeoMillis >= 100) { // parpadeo rápido
        ledEncendido = !ledEncendido;
        digitalWrite(LED_PIN, ledEncendido);
        ultimoParpadeoMillis = ahora;
      }
      break;
  }
}

void setup() {
  pinMode(LED_PIN, OUTPUT);
  pinMode(RESET_BUTTON_PIN, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(RESET_BUTTON_PIN), resetButtonInterruptHandler, FALLING);

  Serial.begin(9600);

  agentState = AgentState::BOOT;
}

void loop() {

  actualizarLed();

  if (resetPending) {
    DEBUG_PRINTLN("[DEBUG] reset por boton -> WAITING_SETUP");
    resetPending = false;
  }

  switch (agentState) {
    case AgentState::BOOT:
      handleBootState();
      break;
    case AgentState::WAITING_SETUP:
      handleWaitingSetupState();
      break;
    case AgentState::RUNNING:
      handleRunningState();
      break;
    case AgentState::FINISH:
      handleFinishState();
      break;
  }
}
```

### Pendientes y vacíos conocidos — Fase 3 (firmware ESP32)

Aceptados deliberadamente para llegar a un mínimo viable; no resueltos por decisión consciente de alcance, no por descuido.

- **Validación de percepto y de Setup ausente.** `toInt()` retorna `0` silenciosamente
  ante entradas mal formadas, tanto en `handleWaitingSetupState` (Setup corrupto)
  como en `handleRunningState` (percepto corrupto). En Fase 2 (`agente.py`), un
  percepto inválido se reportaba explícitamente (`"percepto invalido recibido"`)
  y un Setup mal formado lanzaba una excepción. Aquí, en su lugar, el agente
  simplemente actúa como si el valor fuera `0`, sin ningún aviso.
- **Uso de `String` en vez de buffer `char` fijo.** Puede fragmentar el heap en
  ejecuciones de muy larga duración. Válido para el alcance actual (percepts
  cortos, ciclos de Setup periódicos); a revisar si el nodo pasa a operar de
  forma continua por días (ej. integración con ESP-NOW en fases futuras).
- **Sin indicador visual de estado (LED).** Se discutió como buena práctica
  antes de escribir código, pero no se implementó. Hoy el único diagnóstico
  disponible es el puerto serial (con `DEBUG_MODE`).
- **Reseteo de `performance` acoplado al próximo Setup, no al botón de reset.**
  Presionar el botón no limpia `performance` de inmediato; solo lo hace
  `handleWaitingSetupState` cuando efectivamente llega un nuevo `N,celda_inicial`.
  No fue una decisión explícita — es el comportamiento por defecto de la
  implementación, pendiente de confirmar si es el deseado.
- **`mundo2.nlogox` sigue apuntando al puerto virtual de la Fase 2** (`COM2`,
  vía Free Virtual Serial Ports). Falta reemplazarlo por el puerto COM real
  que Windows asigna al ESP32 físico, y retirar `agente.py` del flujo de
  ejecución (queda obsoleto en esta fase).
- **Reinicio automático del ESP32 al abrir el puerto serial** (comportamiento
  de hardware vía DTR/RTS, no del firmware) no ha sido confirmado en hardware
  real, solo anticipado. A verificar en la próxima sesión.


https://wokwi.com/projects/468558655121830913
