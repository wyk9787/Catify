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

def generate_data():
    cat1 = Cat('sesame', 1, 'black', 'domestic short hair', 123, 321)
    cat2 = Cat('coconut', 2, 'mixed', 'domestic short hair', 1115, 1116)
    cat3 = Cat('pineapple', 3, 'orange', 'tiger', 116, 118)
    cat4 = Cat('fruit', 4, 'grey', 'Russian Blue', 220, 220)
    all_cats.append([cat1, cat2, cat3, cat4])
