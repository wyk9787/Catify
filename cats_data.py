# Keeps track of all cats' information
all_cats = []

class Cat:
    def __init__(self, id, name, color, breed, lon, lat, neutered=False,
            owner='None'):
        self.id = id
        self.name = name
        self.color=color
        self.breed = breed
        self.location = [(lon, lat)]

    # TODO: Add image to cat's info
    # Add a new location to the cat instance
    def add_location_and_image(self, longitude, latitude):
        self.location.append((longitude, latitude))

    # Returns the number of locations the cat has been found
    def get_size(self):
        return len(self.location)
