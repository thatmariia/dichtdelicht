import firebase_admin
from firebase_admin import credentials, firestore

from DTO.home import Home
from DTO.LED import LED
from DTO.pattern import Pattern
from DTO.room import Room
from DTO.user import User


def get_subcollection(snapshot, name):
    ref = snapshot.reference
    return ref.collection(name).stream()

def parse_LED_db(LED_data, patterns: [Pattern]):
    for led in LED_data:
        dict = led.to_dict()
        name = dict['name']
        r = dict['R']
        g = dict['G']
        b = dict['B']
        pattern = next(pat for pat in patterns if pat.name == dict['pattern_name'])
        yield LED(name, r, g, b, pattern)

def parse_rooms_db(room_data, patterns: [Pattern]):
    for room in room_data:
        dict = room.to_dict()
        name = dict['name']
        LEDs = parse_LED_db(get_subcollection(room, 'LED'), patterns)
        yield Room(name, list(LEDs))

def parse_homes_db(home_data, patterns: [Pattern]):
    for home in home_data:
        dict = home.to_dict()
        name = dict['name']
        rooms = parse_rooms_db(get_subcollection(home, 'rooms'), patterns)
        yield Home(name, list(rooms))

def parse_patterns_db(pattern_data):
    for pattern in pattern_data:
        dict = pattern.to_dict()
        name = dict['name']
        rpm = dict['rpm']
        yield Pattern(name, rpm)

def read_database() -> [Home]:
    # Use the application default credentials
    cred = credentials.ApplicationDefault()
    firebase_admin.initialize_app(cred, {
        'projectId': 'dichtdelicht',
    })

    db = firestore.client()

    patterns_ref = db.collection(u'pattern')
    home_ref = db.collection(u'home')

    patterns = parse_patterns_db(patterns_ref.stream())
    patterns = list(patterns)
    homes = parse_homes_db(home_ref.stream(), patterns)

    return homes

def main():
    print("Hello World!")
    homes = read_database()

    [ print(home) for home in homes ]


if __name__ == "__main__":
    main()
