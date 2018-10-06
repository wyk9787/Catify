from cats_data import *
from util import *
from breed import *

from flask import Flask
from flask import request
from flask import jsonify
import json

app = Flask(__name__)

activity_range = 20

@app.route('/similarcats', methods=['GET'])
def similar_cats():
    target_cats = [] 
    lat = request.args.get('lat')
    lon = request.args.get('lon')
    color = request.args.get('color')
    breed = get_breed(filename, breed_project, model_id) 
    for cat in all_cats:
        distance = calculate_distance(float(lat), float(lon), cat.lat, cat.lon)
        if distance < activity_range:
            target_cats.append(cat)
    
    # Serialize to JSON string then sends the response back
    jsonify([cat.__dict__ for cat in target_cats])
            
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4444)
