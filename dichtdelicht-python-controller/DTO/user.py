from DTO.home import Home

class User:
    def __init__(self, user_id, username, homes : [Home]):
        self.user_id = user_id
        self.username = username
        self.homes = homes
