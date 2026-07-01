import serial.tools.list_ports

for puerto in serial.tools.list_ports.comports():
    print(puerto.device, "-", puerto.description)