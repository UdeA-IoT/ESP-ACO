# Experimento 0

![img](experimento_0.png)


## Arena

```
Env Width → 400
Env Height → 300
```

## Agente

### Init

```js
(CONST, VAR, FUNC, robot, params) => {
  CONST.maxForwardSpeed = 0.15;
  CONST.maxAngularSpeed = 0.03;
  VAR.collisions = 0;
  VAR.tick = 0;
}
```

### Loop


```js
(sensors, actuators) => {
  const nearbyRobots = sensors.polygons?.left?.reading?.robots 
                     + sensors.polygons?.right?.reading?.robots || 0;

  if (nearbyRobots > 0) {
    VAR.collisions += 1;
  }

  const angularSpeed = (Math.random() - 0.5) * CONST.maxAngularSpeed;

  return {
    linearVel: CONST.maxForwardSpeed * robot.velocityScale,
    angularVel: angularSpeed * robot.velocityScale,
    type: robot.SPEED_TYPES.RELATIVE
  };
}
```

### Con debug


```js
(CONST, VAR, FUNC, robot, params) => {
  CONST.maxForwardSpeed = 0.15;
  CONST.maxAngularSpeed = 0.03;
  VAR.collisions = 0;
  VAR.tick = 0;
}
```

```js
(sensors, actuators) => {
  const nearbyRobots = (sensors.polygons?.left?.reading?.robots || 0)
                     + (sensors.polygons?.right?.reading?.robots || 0);

  if (nearbyRobots > 0) {
    VAR.collisions += 1;
  }

  // Imprime cada 100 ticks
  if (VAR.tick % 100 === 0) {
    console.log(`Robot colisiones: ${VAR.collisions} | tick: ${VAR.tick}`);
  }

  VAR.tick = (VAR.tick || 0) + 1;

  const angularSpeed = (Math.random() - 0.5) * CONST.maxAngularSpeed;

  return {
    linearVel: CONST.maxForwardSpeed * robot.velocityScale,
    angularVel: angularSpeed * robot.velocityScale,
    type: robot.SPEED_TYPES.RELATIVE
  };
}
```

## Ver 

* https://bots.cs.mun.ca/software/
* https://ccl.northwestern.edu/courses.shtml
* https://microsoft.github.io/ai-agents-for-beginners/translations/es/
* https://github.com/microsoft/ai-for-beginners
* https://mit-mi.github.io/how2ai-course/spring2025/
* https://introml.mit.edu/spring25/
* https://github.com/glouppe/info8006-introduction-to-ai
* https://ocw.mit.edu/courses/6-034-artificial-intelligence-fall-2010/
* https://github.com/estebancalabria/Intro-Ia
* https://github.com/fizcogar/Intro-IA
* https://github.com/rohitg00/ai-engineering-from-scratch
* https://github.com/institutohumai/recursos-ia
* https://bots.cs.mun.ca/waggle1/
* https://dgarzonramos.github.io/robotics101/p2/
* https://dgarzonramos.com/
* https://courses.csail.mit.edu/6.034s/calendar
* https://bahh723.github.io/ai2024fa/

