#include <Arduino.h>

// Definición fija de pines para tu NodeMCU-32S física
const int LED_PIN = 2;            // LED azul integrado de la placa
const int POTENCIOMETRO_PIN = 34; // Pin de entrada analógica limpia (ADC1_CH6)

unsigned long tiempoPrevio = 0;
const long intervaloEnvio = 100;  // Enviar datos cada 100ms

void setup() {
  pinMode(LED_PIN, OUTPUT);
  pinMode(POTENCIOMETRO_PIN, INPUT);

  // Inicializar puerto Serial a la velocidad de NetLogo
  Serial.begin(9600);
}

void loop() {
  // 1. RECIBIR ACCIONES DESDE NETLOGO
  if (Serial.available() > 0) {
    char comando = Serial.read();

    if (comando == '1') {
      digitalWrite(LED_PIN, HIGH); // Enciende el LED azul
    } 
    else if (comando == '0') {
      digitalWrite(LED_PIN, LOW);  // Apaga el LED azul
    }
  }

  // 2. ENVIAR DATOS HACIA NETLOGO
  unsigned long tiempoActual = millis();
  if (tiempoActual - tiempoPrevio >= intervaloEnvio) {
    tiempoPrevio = tiempoActual;

    int valorAnalogico = analogRead(POTENCIOMETRO_PIN);
    Serial.println(valorAnalogico); // Envía el valor (0-4095) + salto de línea
  }
}