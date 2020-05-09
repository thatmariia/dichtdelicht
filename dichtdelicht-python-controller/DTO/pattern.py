class Pattern:
    def __init__(self, name, rpm):
        self.name = name
        self.rpm = rpm

    def __str__(self):
        return f"Pattern {{ name: '{self.name}', rpm: {self.rpm} }}" 