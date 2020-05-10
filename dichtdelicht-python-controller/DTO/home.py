from DTO.room import Room

class Home:
    def __init__(self, db_id: str, name: str, rooms: [Room]):
        self.db_id = db_id
        self.name = name
        self.rooms = rooms

    def to_dict(self) -> {str, str}:
       return {
           u'name': self.name 
        } 

    def __str__(self):
        room_str = [str(room) for room in self.rooms]
        return f"Home {{ name: '{self.name}', # rooms: {len(self.rooms)}  rooms: {room_str}  }}" 