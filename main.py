from cats_data import *
from flask import Flask
from flask import request

catify = Flask(__name__)

generate_data()

@catify.route('/newcat', methods=['GET'])
def add_new_cat():
    id = len(cats);
    name = str(request.args.get('name'))
    color = str(request.args.get('color'))
    breed = "Mixed" # TODO: Get breed from similar_cats
    lon = float(request.args.get('lon'))
    lat = float(request.args.get('lat'))
    new_cat = Cat(id, name, color, breed, lon, lat)
    cats.append(new_cat)
    return str(all_cats[0].location[0])

@catify.route('/confirm', methods=['GET'])
def confirm_cat():
    id = int(request.args.get('id'))
    lon = float(request.args.get('lon'))
    lat = float(request.args.get('lat'))
    cats[int(id)].add_location_and_image(float(lon), float(lat)) # Adding a new location to the cat's info
    location = cats[id].get_center()
    return "Cat %d is centered around (%f, %f)" % (id, location[0], location[1])
