# Keeps track of all cats' information
cats = []

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
    def add_location_and_image(self, lon, lat):
        self.location.append((lon, lat))
        lon_sum = 0
        lat_sum = 0
        for point in self.location:
            lon_sum += point[0]
            lat_sum += point[1]
        self.center = (lon_sum/float(len(self.location)), lat_sum/float(len(self.location)))
        print self.center

    # Returns the number of locations the cat has been found
    def get_size(self):
        return len(self.location)

def generate_data():
    cat1 = Cat(1, 'sesame', 'black', 'domestic short hair', 123, 321)
    cat2 = Cat(2, 'coconut', 'mixed', 'domestic short hair', 1115, 1116)
    cat3 = Cat(3, 'pineapple', 'orange', 'tiger', 116, 118)
    cat4 = Cat(4, 'fruit', 'grey', 'Russian Blue', 220, 220)
    cats.extend((cat1, cat2, cat3, cat4))

"""generate_data()
cats[1].add_location_and_image(111, 222)
cats[1].add_location_and_image(1000, 2000)
cats[1].add_location_and_image(201, 108)"""
