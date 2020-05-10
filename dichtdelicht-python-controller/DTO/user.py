from DTO.home import Home

class User:
    def __init__(self, db_id, user_id, username, homes : [Home]):
        self.db_id = db_id
        
        self.user_id = user_id
        self.username = username
        self.homes = homes
