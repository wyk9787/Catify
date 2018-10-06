from cats_data import *
from util import *

from flask import Flask
from flask import request
from flask import jsonify
import json

app = Flask(__name__)

@app.route('/allcats/', methods=['GET'])
def all_cats():
    target_cats = [] 
    lat = request.args.get('lat')
    lon = request.args.get('lon')
    max_distance = int(request.args.get('dis'))
    for cat in cats:
        distance = calculate_distance(float(lat), float(lon), 
                cat.location[0][0], cat.location[0][1])
        # If this cat is within the distance required
        if distance < max_distance:
            target_cats.append(cat)
    
    # Serialize to JSON string then sends the response back
    jsonify([cat.__dict__ for cat in target_cats])
    return 'success'

# TEST
#
# if __name__ == '__main__':
#     generate_data()
#     app.run()
