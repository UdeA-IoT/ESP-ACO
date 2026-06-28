class VacuumEnvironment:
    """
    Entorno de dos celdas para el mundo de la aspiradora.
    Equivalent NetLogo: patches + globals
    Equivalent ESP32:   variables globales de estado
    """
    loc_A = (0, 0)
    loc_B = (1, 0)

    def __init__(self, status_A='Dirty', status_B='Dirty'):
        """
        Inicializa el entorno con el estado de cada celda.
        Equivalent NetLogo: setup de patches
        Equivalent ESP32:   setup()
        """
        self.status = {
            self.loc_A: status_A,
            self.loc_B: status_B
        }

    def get_percept(self, location):
        """
        Retorna la percepcion del agente en su ubicacion actual.
        Equivalent NetLogo: patch-here
        Equivalent ESP32:   lectura de sensores
        """
        return (location, self.status[location])

    def execute_action(self, location, action):
        """
        Aplica la accion del agente y retorna la nueva ubicacion.
        Equivalent NetLogo: ask turtles [...]
        Equivalent ESP32:   actuadores en loop()
        """
        if action == 'Suck':
            self.status[location] = 'Clean'
        elif action == 'Right':
            location = self.loc_B
        elif action == 'Left':
            location = self.loc_A
        return location

    def is_done(self):
        """
        Retorna True si ambas celdas estan limpias.
        Equivalent NetLogo: condicion de parada en go
        Equivalent ESP32:   condicion de salida del loop
        """
        return all(s == 'Clean' for s in self.status.values())

    def print_status(self):
        """Imprime el estado actual del entorno."""
        print(f"status: {self.status}")

class ModelBasedVacuumAgent:
    """
    Agente basado en modelo para el mundo de la aspiradora.
    Equivalent NetLogo: turtle con variables propias de estado
    Equivalent ESP32:   variables globales de modelo en setup()
    """

    def __init__(self, location):
        """
        Inicializa el agente con modelo interno vacio.
        Equivalent NetLogo: turtle-own [model-A model-B]
        Equivalent ESP32:   variables globales del modelo en setup()
        """
        self.location = location
        self.performance = 0
        self.model = {
            VacuumEnvironment.loc_A: None,
            VacuumEnvironment.loc_B: None
        }

    def percept(self, env):
        """
        Obtiene la percepcion actual desde el entorno.
        Equivalent NetLogo: patch-here
        Equivalent ESP32:   lectura de sensores
        """
        return env.get_percept(self.location)

    def update_model(self, location, status):
        """
        Actualiza el modelo interno con la percepcion actual.
        Equivalent NetLogo: set model-A / set model-B
        Equivalent ESP32:   actualizacion de variables de modelo
        """
        self.model[location] = status

    def act(self, env):
        """
        Decide accion basada en percepcion actual y modelo interno.
        Equivalent NetLogo: reglas condicion-accion con memoria
        Equivalent ESP32:   logica secuencial en loop()
        """
        location, status = self.percept(env)
        self.update_model(location, status)

        if self.model[VacuumEnvironment.loc_A] == self.model[VacuumEnvironment.loc_B] == 'Clean':
            action = 'NoOp'
        elif status == 'Dirty':
            action = 'Suck'
            self.performance += 1
        elif location == VacuumEnvironment.loc_A:
            action = 'Right'
        else:
            action = 'Left'

        self.location = env.execute_action(self.location, action)
        return action

    def run(self, env, steps=5):
        """
        Ejecuta la simulacion por un numero de pasos.
        Equivalent NetLogo: repeat steps [go]
        Equivalent ESP32:   loop() con contador
        """
        for _ in range(steps):
            percept = self.percept(env)
            action = self.act(env)
            print(f"<Agent> perceives {percept} and does {action}")


if __name__ == '__main__':
    env = VacuumEnvironment(status_A='Dirty', status_B='Clean')
    agent = ModelBasedVacuumAgent(location=(0, 0))
    agent.run(env, steps=5)