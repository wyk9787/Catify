from cats_data import *
from util import *
from breed import *

from flask import Flask
from flask import request
from flask import jsonify
import json

from PIL import Image

app = Flask(__name__)

# Used to append at the end of the file
name_num = 0

# Cats' activity range
activity_range = 3

@app.route('/similarcats', methods=['POST'])
def similar_cats():
    img = Image.open(request.files['file'])
<<<<<<< HEAD
    filename = 'tmp/tmp_' + str(generate_num) + '.png'
    img.save(filename, "png")

    target_cats = [] 
=======
    return 'Success!'
    target_cats = []
>>>>>>> b3ac494f933b8c647f11f11ec55e04057ac4d8b7
    lat = float(request.args.get('lat'))
    lon = float(request.args.get('lon'))
    color = request.args.get('color')
    breed_score, breed = get_breed_and_score(filename)

    # Loop through all cats in the databse and find assign a score to each cat
    # Scores are scored as below:
    #   100: Color, distance and breed match plus both breed score > 0.5
    #    80: Color, distance, and breed match plus one of the breed score
    #        > 0.5
    #    70: Color, distance, and breed match but neither breed score > 0.5
    #    60: Color and distance match, but breed doesn't match plus either one
    #        of them has a breed score < 0.5
    #    40: Color, distance match, but breed doesn't match plus both of them
    #        has a breed score > 0.5
    #    20: Color matches but distance doesn't match
    #    10: Distance match but color doesn't match
    #     0: Neither of color nor distance mathces
    for cat in cats:
        distance = calculate_distance(lat, lon, cat.lat, cat.lon)
        # Basic requirement:
        #   1. distance <= activity_range
        #   2. same color
        if distance <= activity_range and color == cat.color:
            if breed == cat.breed:
                if breed_score > 0.5 and cat.breed_score > 0.5:
                    # If every single criteria meets, then we assign
                    # a confidence score of 100
                    target_cats.append((cat, 100))
                elif breed_score > 0.5 or cat.breed_score > 0.5:
                    # If the one of the breed score is lower than 0.5, we will assign 80
                    # to this cat
                    target_cats.append((cat, 80))
                else:
                    # If neither of the breed score is greater than 0.5, then
                    # we will assign 70 to this cat
                    target_cats.append((cat, 70))
            else:
                # If either the target cat or the cat from the database has
                # a credit score lower than 0.5, than we assign 60 to this
                # cat
                if cat.breed_score < 0.5 or cat.breed_score < 0.5:
                    target_cats.append((cat, 60))
                else:
                    target_cats.append((cat, 40))
        # If the color matches, then we assign 20 to this cat
        elif color == cat.color:
            target_cats.append((cat, 20))
        # If this cat is within the distance, then we assign 10 to this cat
        elif distance <= activity_range:
            target_cats.append((cat, 10))
        # If this cat doesn't meet any criteria, then it has a score of 0
        else:
            target_cats.append((cat, 0))

    # Sort those target cats according to its score
    target_cats.sort(key=lambda cat : cat[1])

    # Serialize to JSON string then sends the response back
    jsonify([cat.__dict__ for cat in target_cats])
<<<<<<< HEAD
    
def generate_num():
    name_num += 1
    return name_num
=======
>>>>>>> b3ac494f933b8c647f11f11ec55e04057ac4d8b7

if __name__ == '__main__':
    app.run()
