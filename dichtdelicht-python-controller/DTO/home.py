from DTO.room import Room

class Home:
    def __init__(self, name, rooms: [Room]):
        self.name = name
        self.rooms = rooms

    def __str__(self):
        room_str = [str(room) + "\n" for room in self.rooms]
        return f"Home {{ name: '{self.name}', # rooms: {len(self.rooms)}  rooms: {room_str}  }}" 