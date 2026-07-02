"""
Arquitectura de agente (Capa 2) - Fase 2 del ejercicio AIMA "conciencia de ubicacion".

Envuelve el programa de agente puro (ver agente_base.py) con la comunicacion
serial hacia NetLogo. La logica de ModelBasedLocationAgent se repite aqui sin
modificaciones, solo para mantener este modulo autocontenido y ejecutable de
forma independiente.

Protocolo de comunicacion (ver README.md, seccion 7):
    Setup    (NetLogo -> Python, una vez):    "N,celda_inicial\n"
    Percepto (NetLogo -> Python, cada tick):  "celda_actual\n"
    Accion   (Python -> NetLogo, cada tick):  "A\n" (avanzar) o "N\n" (no-op)
    Salida   (NetLogo -> Python, al cerrar):  "EXIT\n"

Equivalent NetLogo: extension py + apertura de sesion serial (setup-conexion)
Equivalent ESP32:   Serial.begin(), Serial.available(), Serial.println()
"""

import serial

PUERTO_SERIAL = 'COM1'
BAUDRATE_SERIAL = 9600

ACCION_AVANZAR = 'A'
ACCION_NOOP = 'N'

SENAL_SALIDA = 'EXIT'


def abrir_conexion():
    """
    Abre el puerto serial virtual del lado del agente.

    Se usa timeout=1 (bloqueante con limite de espera), consistente con el
    esquema SINCRONO de pregunta-respuesta adoptado en esta fase: el agente
    puede permitirse esperar brevemente una linea completa, ya que aun no
    existe la restriccion de tiempo real que si tendra el ESP32 (Fase 3).

    Equivalent NetLogo: py:run "ser = serial.Serial(...)" dentro de conectar-agente
    Equivalent ESP32:   Serial.begin(BAUDRATE_SERIAL) en setup()
    """
    conexion = serial.Serial(PUERTO_SERIAL, BAUDRATE_SERIAL, timeout=1)
    print(f"[Agente] puerto abierto: {conexion.name}")
    return conexion


def leer_percepto(conexion):
    """
    Lee una linea del puerto y la interpreta segun el protocolo.

    Retorna:
        int          -> percepto valido (celda actual)
        SENAL_SALIDA -> si NetLogo solicito el cierre de la conexion
        None         -> si no llego nada dentro del timeout, o si la linea
                        recibida no es interpretable (percepto corrupto)

    Equivalent NetLogo: linea extraida del buffer en leer_ultima()
    Equivalent ESP32:   Serial.available() + Serial.read() (lectura no bloqueante)
    """
    linea = conexion.readline().decode('utf-8', errors='ignore').strip()

    if linea == '':
        return None

    if linea == SENAL_SALIDA:
        return SENAL_SALIDA

    try:
        return int(linea)
    except ValueError:
        print(f"[Agente] percepto invalido recibido: '{linea}'")
        return None


def escribir_accion(conexion, accion):
    """
    Escribe la accion decidida por el agente, seguida de salto de linea,
    tal como exige el lado de NetLogo (lectura por linea completa).

    Equivalent NetLogo: ser.readline() dentro de consultar-agente
    Equivalent ESP32:   Serial.println(valorAnalogico) (mismo patron, en sentido inverso)
    """
    mensaje = f"{accion}\n"
    conexion.write(mensaje.encode('utf-8'))


class ModelBasedLocationAgent:
    """
    Agente basado en modelo para el mundo lineal de N celdas.

    Identico en logica interna a la version de agente_base.py (Capa 1 pura).
    No contiene ninguna instruccion de entrada/salida: la comunicacion serial
    es siempre responsabilidad del bucle principal (Capa 2), nunca de esta
    clase.

    Equivalent NetLogo: turtle con variables propias de estado
    Equivalent ESP32:   variables globales del modelo en setup()
    """

    def __init__(self, n_celdas, celda_inicial):
        self.n_celdas = n_celdas
        self.model = celda_inicial
        self.performance = 0

    def act_from_percept(self, percepto_celda):
        if self.model != percepto_celda:
            print(f"[Agente] desincronizacion: modelo={self.model} percepto={percepto_celda}")
            self.model = percepto_celda

        prediccion = (self.model + 1) % self.n_celdas
        if prediccion == 0:
            self.performance += 1

        self.model = prediccion

        return ACCION_AVANZAR


def leer_setup(conexion):
    """
    Espera de forma BLOQUEANTE e indefinida el mensaje inicial de Setup
    enviado por NetLogo, y lo interpreta como N (tamano del mundo) y
    celda_inicial (ubicacion de arranque del agente).

    A diferencia de leer_percepto, aqui el bloqueo indefinido es intencional:
    sin este dato el agente no puede instanciarse, asi que no tiene sentido
    continuar sin recibirlo.

    Equivalent NetLogo: mensaje de Setup enviado en conectar-agente
    Equivalent ESP32:   No aplica todavia (en Fase 3 estos valores se fijarian
                        como constantes de firmware, sin negociacion inicial)
    """
    print("[Agente] esperando mensaje de Setup...")
    linea = ''
    while linea == '':
        linea = conexion.readline().decode('utf-8', errors='ignore').strip()

    n_celdas_str, celda_inicial_str = linea.split(',')
    return int(n_celdas_str), int(celda_inicial_str)


if __name__ == '__main__':
    # Arquitectura completa (Capa 2 envolviendo Capa 1).
    # Orden de arranque: abrir puerto -> esperar Setup -> instanciar agente
    # -> entrar al ciclo continuo de percepcion y accion.
    conexion = abrir_conexion()

    n_celdas, celda_inicial = leer_setup(conexion)
    print(f"[Agente] setup recibido: N={n_celdas} celda_inicial={celda_inicial}")

    agente = ModelBasedLocationAgent(n_celdas=n_celdas, celda_inicial=celda_inicial)

    try:
        while True:
            percepto = leer_percepto(conexion)

            if percepto == SENAL_SALIDA:
                print("[Agente] senal de desconexion recibida desde NetLogo.")
                break

            if percepto is not None:
                accion = agente.act_from_percept(percepto)
                escribir_accion(conexion, accion)
                print(f"[Agente] percepto={percepto} -> accion={accion} | modelo={agente.model} performance={agente.performance}")

    except KeyboardInterrupt:
        # Via de salida secundaria: solo necesaria si, por alguna razon, la
        # senal EXIT no llega (por ejemplo, si NetLogo se cierra abruptamente
        # sin ejecutar desconectar-agente).
        print("[Agente] detenido manualmente (Ctrl+C).")

    finally:
        if conexion.is_open:
            conexion.close()
            print("[Agente] puerto cerrado correctamente.")
