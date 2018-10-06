from cats_data import *
from util import *
from flask import Flask
from flask import request
from flask import jsonify
import json

catify = Flask(__name__)

generate_data()

@catify.route('/newcat', methods=['GET'])
def add_new_cat():
    id = len(cats);
    name = str(request.args.get('name'))
    color = str(request.args.get('color'))
    breed = "Mixed" # TODO: Get breed from similar_cats
    breed_score = 0.9
    lon = float(request.args.get('lon'))
    lat = float(request.args.get('lat'))
    new_cat = Cat(id, name, color, breed, breed_score, lon, lat)
    cats.append(new_cat)
    return "Success"

@catify.route('/confirm', methods=['GET'])
def confirm_cat():
    id = int(request.args.get('id'))
    lon = float(request.args.get('lon'))
    lat = float(request.args.get('lat'))
    cats[int(id)].add_location_and_image(float(lon), float(lat)) # Adding a new location to the cat's info
    location = cats[id].center
    return "Cat %d is centered around (%f, %f)" % (id, location['lon'], location['lat'])

@catify.route('/allcats', methods=['GET'])
def all_cats():
    target_cats = []
    lat = request.args.get('lat')
    lon = request.args.get('lon')
    max_distance = int(request.args.get('dis'))
    for cat in cats:
        distance = calculate_distance(float(lat), float(lon),
                cat.center['lon'], cat.center['lat'])
        # If this cat is within the distance required
        if distance < max_distance:
            target_cats.append(cat)

    # Serialize to JSON string then sends the response back
    jsonify([cat.__dict__ for cat in target_cats])
    print json.dumps([cat.__dict__ for cat in target_cats])
    return "success"
