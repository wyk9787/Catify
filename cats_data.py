# Keeps track of all cats' information
cats = []

class Cat:
    def __init__(self, id, name, color, breed, breed_score, lon, lat, neutered=False,
            owner='None'):
        self.id = id
        self.name = name
        self.color=color
        self.breed = breed
        self.breed_score = breed_score
        self.location = [{'lon' : lon, 'lat' : lat}]
        self.center = {'lon' : lon, 'lat' : lat}

    # TODO: Add image to cat's info
    # Add a new location to the cat instance
    def add_location_and_image(self, lon, lat):
        self.location.append({'lon' : lon, 'lat' : lat})
        lon_sum = 0
        lat_sum = 0
        for point in self.location:
            lon_sum += point['lon']
            lat_sum += point['lat']
        self.center['lon'] = lon_sum/float(len(self.location))
        self.center['lat'] = lat_sum/float(len(self.location))
        print self.center

    # Returns the number of locations the cat has been found
    def get_size(self):
        return len(self.location)

def generate_data():
    cat0 = Cat(0, 'plum', 'black', 'Bombay', 0.99, 981, 901)
    cat1 = Cat(1, 'sesame', 'black', 'AmericanShorthair', 0.8, 123, 321)
    cat2 = Cat(2, 'coconut', 'mixed', 'AmericanShorthair', 0.3, 1115, 1116)
    cat3 = Cat(3, 'pineapple', 'orange', 'tiger', 0.6, 116, 118)
    cat4 = Cat(4, 'fruit', 'grey', 'Russian Blue', 0.9, 220, 220)
    cat5 = Cat(5, 'mochi', 'white', 'toy', 0.01, 210, 300)
    cat6 = Cat(6, 'matcha', 'green', 'Egyptian Mau', 0.1, 400, 1190)
    cat7 = Cat(7, 'Wiki', 'brown', 'Siamese', 0.2, 212, 499)
    cat8 = Cat(8, 'chocho', 'white', 'Himalayan', 0.8, 987, 1190)
    cat9 = Cat(9, 'pirate', 'oraange', 'Somali', 0.5, 524, 1029)
    cats.extend((cat0, cat1, cat2, cat3, cat4, cat5, cat6, cat7, cat8, cat9))

"""generate_data()
cats[1].add_location_and_image(111, 222)
cats[1].add_location_and_image(1000, 2000)
cats[1].add_location_and_image(201, 108)"""
