from DTO.home import Home
from DTO.LED import LED
from DTO.pattern import Pattern
from DTO.room import Room

import firebase_admin
from firebase_admin import credentials, firestore

class Repository:

    def __init__(self):
        # Use the application default credentials
        cred = credentials.ApplicationDefault()
        firebase_admin.initialize_app(cred, {
            'projectId': 'dichtdelicht',
        })

        self.db = firestore.client()

    def get_subcollection(self, snapshot, name):
        ref = snapshot.reference
        return ref.collection(name).stream()

    def parse_patterns_db(self, pattern_dict):
        t = pattern_dict['type']
        rpm = pattern_dict['rpm']
        freq = pattern_dict['frequency']
        return Pattern(t, rpm, freq)

    def parse_LED_db(self, LED_data):
        for led in LED_data:
            dict = led.to_dict()
            name = dict['name']
            r = dict['R']
            g = dict['G']
            b = dict['B']

            pattern = self.parse_patterns_db(dict['pattern'])
            yield LED(led.id, name, r, g, b, pattern)

    def parse_rooms_db(self, room_data):
        for room in room_data:
            dict = room.to_dict()
            name = dict['name']

            if name == "balcony":
                leds = self.get_subcollection(room, 'LED')
                leds = list(leds)

            LEDs = self.parse_LED_db(self.get_subcollection(room, 'LED'))
            yield Room(room.id, name, list(LEDs))

    def parse_homes_db(self, home_data):
        for home in home_data:
            dict = home.to_dict()
            name = dict['name']
            rooms = self.parse_rooms_db(self.get_subcollection(home, 'rooms'))
            yield Home(home.id, name, list(rooms))

    def read_homes_db(self) -> [Home]:
        home_ref = self.db.collection(u'home')
        homes = self.parse_homes_db(home_ref.stream())
        return homes

    def write_led_db(self, led: LED, room_ref):
        led_ref = room_ref.collection(u'LED').document(led.db_id)
        led_ref.update(led.to_dict())

    def write_room_db(self, room: Room, home_ref):
        room_ref = home_ref.collection(u'rooms').document(room.db_id)
        room_ref.update(room.to_dict())

        for led in room.LEDs:
            self.write_led_db(led, room_ref)

    def write_home_db(self, home: Home):
        home_ref = self.db.collection(u'home').document(home.db_id)
        home_ref.update(home.to_dict())

        for room in home.rooms:
            self.write_room_db(room, home_ref)
