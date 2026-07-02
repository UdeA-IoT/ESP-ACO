![Built with AI](https://img.shields.io/badge/Built%20with-AI-blue.svg)

# Ejemplo 4 

Hacer que el microcontrolador remplace el agente de netlogo de modo que lo que este hace. Sea realizado por la ESP32.

```
to go
  ; Pedimos a la tortuga que se mueva
  ask turtles [
    mover-agente
  ]
  
  tick
end

to mover-agente
  ; Calcular en qué celda está actualmente el agente
  let celda-actual floor (xcor / (M + 1))
  
  ; Avanzar a la siguiente celda (con wrap a 0 al llegar al final)
  let siguiente-celda (celda-actual + 1) mod N
  
  ; Calcular el centro exacto de la siguiente celda
  let nuevo-x (siguiente-celda * (M + 1)) + ((M + 1) / 2)
  let nuevo-y (M + 1) / 2
  
  setxy nuevo-x nuevo-y
end
```

La implementacion del agente sera siguiendo el modelo Agente basado en modelo (explicado en el libro de Inteligencia artificial un enfoque moderno). 


Inicialmente necesito adaptar el agente de modo que:
1. Implemente en python el enviroment de netlogo.
2. Logre interactuar con este mundo empleando el template de Norvin pero adaptandolo al entorno de tal manera que. Cuando se cree, se inicialice en una celda y tenga un contexto real del mundo (numero de celdas).
   

El objetivo de la ESP32 sera imitar lo que hace el agente enviando comandos seriales para moverlo en la interfaz de netlogo. 


> [!important]
> Este material fue desarrollado con apoyo de herramientas de IA como asistente de redacción y estructuración. El contenido ha sido supervisado, validado y refinado por intervención humana para garantizar su precisión técnica y coherencia pedagógica. No obstante, pueden haber errores.