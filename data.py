all_cats = []

class Cat:
    def ___init__(self, id, name, color, longitude, latitude, neutered=false,
            owner='None'):
        self.id = id
        self.color=color
        self.location = [(longitude, latitude)] 

    def add_location_and_image(self, longitude, latitude):
        self.location.append((longitude, latitude))

    def get_size(self):
        return len(self.location)

