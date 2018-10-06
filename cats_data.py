all_cats = []

class Cat:
    def ___init__(self, id, name, color, breed, lon, lat, neutered=False,
            owner='None'):
        self.id = id
        self.name = name
        self.color=color
        self.breed = breed
        self.location = [(lon, lat)]

    def add_location_and_image(self, longitude, latitude):
        self.location.append((longitude, latitude))

    def get_size(self):
        return len(self.location)
