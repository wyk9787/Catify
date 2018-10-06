from cats_data import *
from util import *

from flask import Flask
from flask import request
from flask import jsonify
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
            


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4444)
