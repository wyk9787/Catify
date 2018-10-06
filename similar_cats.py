from cats_data import *

from flask import Flask
from flask import request
from flask import jsonify
from math import sin, cos, sqrt, atan2, radians
import json

app = Flask(__name__)

@app.route('/allcats', methods=['GET'])
def all_cats():
    target_cats = [] 
    lat = request.args.get('lat')
    lon = request.args.get('lon')
    max_distance = request.args.get('dis')
    for cat in all_cats:
        distance = calculate_distance(float(lat), float(lon), cat.lat, cat.lon)
        if distance < max_distance:
            target_cats.append(cat)
    
    # Serialize to JSON string then sends the response back
    jsonify([cat.__dict__ for cat in target_cats])
            

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

    return distance

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4444)
