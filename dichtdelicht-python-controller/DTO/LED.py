from DTO.pattern import Pattern

class LED:
    def __init__(self, db_id, name, r, g, b, pattern: Pattern):
        self.db_id = db_id
    
        self.name = name
        self.r = r
        self.g = g
        self.b = b
        self.pattern = pattern

    def set(self, r = -1, g = -1, b = -1):
        self.r = r if r >= 0 else self.r
        self.g = g if g >= 0 else self.g
        self.b = b if b >= 0 else self.b

    def to_dict(self):
       return {
           u'name': self.name, 
           u'R': self.r,
           u'G': self.g,
           u'B': self.b,
           u'pattern': self.pattern.to_dict()  
        }

    def __str__(self):
        return f"LED {{ name: '{self.name}', RGB: {self.r}/{self.g}/{self.b}, Pattern: {self.pattern} }}" 