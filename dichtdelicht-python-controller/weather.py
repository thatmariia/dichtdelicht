import requests
import os

class Weather:
    def __init__(self):
        self.key = os.environ['OPENWEAHTER_API_KEY']
        self.ehv_lat = "51.441643"
        self.ehv_long = "5.469722"
    
    def get_current_temperature(self, location: str):    
        openweather_url = "https://api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}"\
                          "&exclude={part}&appid={api_key}&units={units}" \
                          .format(lat=self.ehv_lat, lon=self.ehv_long, part="", api_key=self.key, units="metric")

        r = requests.get(url = openweather_url)
        r = r.json()
        print(r['current']['feels_like'])
