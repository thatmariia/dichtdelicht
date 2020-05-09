from DTO.pattern import Pattern

class LED:
    def __init__(self, name, r, g, b, pattern: Pattern):
        self.name = name
        self.r = r
        self.g = g
        self.b = b
        self.pattern = pattern

    def __str__(self):
        return f"LED {{ name: '{self.name}', RGB: {self.r}/{self.g}/{self.b}, Pattern: {self.pattern} }}" 