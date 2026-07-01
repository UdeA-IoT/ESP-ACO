class LinearWorldEnvironment:

    def __init__(self, n_celdas):
        self.n_celdas = n_celdas

    def get_percept(self, location):
        return location

    def execute_action(self, location, action):
        if action == 'Avanzar':
            location = (location + 1) % self.n_celdas
        return location

    def print_status(self, location):
        print(f"agente en celda: {location}")

class ModelBasedLocationAgent:

    def __init__(self, location, n_celdas):
        self.location = location
        self.n_celdas = n_celdas
        self.model = location
        self.performance = 0

    def percept(self, env):
        return env.get_percept(self.location)

    def update_model(self, percepto):
        if self.model != percepto:
            print(f"<Agent> desincronizacion detectada: modelo={self.model} percepto={percepto}")
        self.model = percepto

    def act(self, env):
        percepto = self.percept(env)
        self.update_model(percepto)

        action = 'Avanzar'

        prediccion = (self.model + 1) % self.n_celdas
        if prediccion == 0:
            self.performance += 1

        self.model = prediccion
        self.location = env.execute_action(self.location, action)

        return action

    def run(self, env, steps=5):
        for _ in range(steps):
            percepto = self.percept(env)
            action = self.act(env)
            print(f"<Agent> perceives {percepto} and does {action} -> nueva celda: {self.location}")


if __name__ == '__main__':
    n = 5
    env = LinearWorldEnvironment(n_celdas=n)
    agent = ModelBasedLocationAgent(location=0, n_celdas=n)
    agent.run(env, steps=8)