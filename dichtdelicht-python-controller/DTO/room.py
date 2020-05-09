from DTO.LED import LED

class Room:
    def __init__(self, name, LEDs : [LED]):
        self.name = name
        self.LEDs = LEDs

    def __str__(self):
        LED_str = [str(led) for led in self.LEDs]
        return f"Room {{ name: '{self.name}', # LEDs: {len(self.LEDs)}  leds: {LED_str}  }}" 