from cats_data import *
from flask import Flask
from flask import request

catify = Flask(__name__)
@catify.route('/newcat')
def add_new_cat():
    id = len(all_cats);
    name = request.args.get('name')
    color = request.args.get('color')
    breed = request.args.get('breed')
    lon = request.args.get('lon')
    lat = request.args.get('lat')
    new_cat = Cat(id, name, color, breed, lon, lat)
    all_cats.append(new_cat)
    return all_cats[0].location[0]
