"""
Programa de agente (Capa 1) - Fase 2 del ejercicio AIMA "conciencia de ubicacion".

Este modulo contiene UNICAMENTE la logica de decision del agente basado en
modelo (Russell & Norvig, Cap. 2), sin ninguna instruccion de entrada/salida.
No importa serial, no abre puertos, no depende de nada externo al percepto
que recibe como parametro.

Equivalent NetLogo: turtle con variables propias de estado (turtles-own)
Equivalent ESP32:   variables globales de modelo definidas en setup()
"""

ACCION_AVANZAR = 'A'
ACCION_NOOP = 'N'


class ModelBasedLocationAgent:
    """
    Agente basado en modelo para el mundo lineal de N celdas.

    A diferencia de ModelBasedVacuumAgent (Fase 1, mundo de la aspiradora),
    este agente no percibe suciedad ni ejecuta la accion 'Suck': el unico
    proposito es mantener una creencia interna (self.model) sobre su propia
    ubicacion, y detectar cuando completa una vuelta al mundo.

    Equivalent NetLogo: turtle con variables propias de estado
    Equivalent ESP32:   variables globales del modelo en setup()
    """

    def __init__(self, n_celdas, celda_inicial):
        """
        Inicializa el agente con el tamano del mundo y su ubicacion inicial.

        Equivalent NetLogo: turtles-own [modelo] + creacion inicial de la turtle
        Equivalent ESP32:   variables globales inicializadas en setup()
        """
        self.n_celdas = n_celdas
        self.model = celda_inicial
        self.performance = 0

    def act_from_percept(self, percepto_celda):
        """
        Decide la accion a partir del percepto recibido (celda actual real).

        Pasos:
        1. Compara el modelo interno contra el percepto; si difieren, se
           reporta una desincronizacion y el modelo se corrige (en este
           mundo determinista, esto nunca deberia ocurrir).
        2. Predice la siguiente celda aplicando la regla de transicion
           conocida por el agente (avance con wrap-around).
        3. Si la prediccion cae en la celda 0, se registra una vuelta
           completa en el contador de desempeno.
        4. Retorna siempre la unica accion posible en este mundo: avanzar.

        Equivalent NetLogo: reglas condicion-accion con memoria (modelo)
        Equivalent ESP32:   logica secuencial en loop(), sin nada de E/S
        """
        if self.model != percepto_celda:
            print(f"[Agente] desincronizacion: modelo={self.model} percepto={percepto_celda}")
            self.model = percepto_celda

        prediccion = (self.model + 1) % self.n_celdas
        if prediccion == 0:
            self.performance += 1

        self.model = prediccion

        return ACCION_AVANZAR


if __name__ == '__main__':
    # Prueba aislada de la Capa 1, sin ningun puerto serial de por medio.
    # Simula manualmente el percepto que en la Fase 2 real provee NetLogo,
    # unicamente para validar la logica de decision antes de envolverla
    # con la comunicacion serial (ver agente.py).
    agente = ModelBasedLocationAgent(n_celdas=5, celda_inicial=0)

    percepto_simulado = 0
    for _ in range(8):
        accion = agente.act_from_percept(percepto_simulado)
        print(f"percepto={percepto_simulado} -> accion={accion} | modelo={agente.model} performance={agente.performance}")

        percepto_simulado = (percepto_simulado + 1) % agente.n_celdas

