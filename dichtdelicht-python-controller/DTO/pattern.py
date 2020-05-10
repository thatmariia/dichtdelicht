class Pattern:
    def __init__(self, type, rpm, frequency):        
        self.type = type
        self.rpm = rpm
        self.frequency = frequency
    
    def to_dict(self):
       return {
           u'type': self.type,
           u'rpm': self.rpm,
           u'frequency': self.frequency 
        }

    def __str__(self):
        return f"Pattern {{ type: '{self.type}', rpm: {self.rpm}, frequency: {self.frequency}}}" 