from repository import Repository
from DTO.home import Home

import random

def set_all_leds_random(home) -> Home:
    for room in home.rooms:
        for led in room.LEDs:
            led.set(r=random.randint(0, 255), g=random.randint(0, 255), b=random.randint(0, 255))
    return home

def main():
    print("Hello World!")
    firestore_repo = Repository()
    homes = firestore_repo.read_homes_db()
    homes = list(homes)

    royal_home = next(h for h in homes if h.name == "royal_house")
    home_new = set_all_leds_random(royal_home)
    firestore_repo.write_home_db(home_new)

if __name__ == "__main__":
    main()
