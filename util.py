from math import sin, cos, sqrt, atan2, radians

name_num = 0

def calculate_distance(lat1, lon1, lat2, lon2):
    # Approximate radius of earth in km
    R = 6373.0

    # Turn four coordinates into radians
    lat1 = radians(lat1)
    lon1 = radians(lon1)
    lat2 = radians(lat2)
    lon2 = radians(lon2)

    # Distance between longitudes and latitudes
    dlon = lon2 - lon1
    dlat = lat2 - lat1

    a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))

    distance = R * c 

    # Convert from km to mile
    return distance / 1.6

def generate_num():
    global name_num
    name_num += 1
    return name_num
