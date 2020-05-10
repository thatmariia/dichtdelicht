from DTO.LED import LED

class Room:
    def __init__(self, db_id, name, LEDs : [LED]):
        self.db_id = db_id
        
        self.name = name
        self.LEDs = LEDs

    def to_dict(self):
       return {
           u'name': self.name 
        }

    def __str__(self):
        LED_str = [str(led) for led in self.LEDs]
        return f"Room {{ name: '{self.name}', # LEDs: {len(self.LEDs)}  leds: {LED_str}  }}" 