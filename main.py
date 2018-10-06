from cats_data import *
from flask import Flask
from flask import request

catify = Flask(__name__)

@catify.route('/newcat', methods=['POST'])
def add_new_cat():
    id = len(all_cats);
    name = request.args.get('name')
    color = request.args.get('color')
    breed = "Mixed" # TODO: Get breed from similar_cats
    lon = request.args.get('lon')
    lat = request.args.get('lat')
    new_cat = Cat(id, name, color, breed, lon, lat)
    cats.append(new_cat)
    return str(all_cats[0].location[0])

@catify.route('/confirm', methods=['GET'])
def confirm_cat():
    id = request.args.get('id')
    lon = request.args.get('lon')
    lat = request.args.get('lat')
    cats[int(id)].add_location_and_image(float(lon), float(lat)) # Adding a new location to the cat's info
    return str(id)
