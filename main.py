from cats_data import *
from util import *
from breed import *

import json
from flask import Flask
from flask import request
from flask import jsonify
from PIL import Image
import os

catify = Flask(__name__)

generate_data()

# Used to append at the end of the file
name_num = 0

# Cats' activity range
activity_range = 3

# Saved values from similar_cats and will be used in either add_new_cat or
# confirm cat 
saved_breed = ''
saved_color = ''
saved_lon = 0
saved_lat = 0
saved_filename = ''

# Constants
img_folder_dir = 'img/'

@catify.route('/newcat', methods=['GET'])
def add_new_cat():
    id = len(cats);
    name = str(request.args.get('name'))
    color = saved_color
    breed = saved_breed
    breed_score = saved_breed_score
    lon = saved_lon 
    lat = saved_lat 
    new_cat = Cat(id, name, color, breed, breed_score, lon, lat)
    cats.append(new_cat)
    os.rename(saved_filename, img_folder_dir + str(id) + '_0.png') 
    return "Success"

@catify.route('/confirm', methods=['GET'])
def confirm_cat():
    id = int(request.args.get('id'))
    lon = saved_lon 
    lat = saved_lat 
    cats[int(id)].add_location_and_image(float(lon), float(lat)) # Adding a new location to the cat's info
    location = cats[id].center
    # Rename the file to 'tmp/id_index.png'
    os.rename(saved_filename, img_folder_dir + str(id) + '_'
            + str(len(cats[id].images) - 1) + '.png') 
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

@catify.route('/similarcats', methods=['POST'])
def similar_cats():
    global saved_lon, saved_lat, saved_breed, saved_breed_score, saved_color, saved_filename
    img = Image.open(request.files['file'])
    filename = img_folder_dir + 'tmp_' + str(generate_num()) + '.png'
    img.save(filename, "png")

    target_cats = [] 
    lat = float(request.args.get('lat'))
    lon = float(request.args.get('lon'))
    color = request.args.get('color')
    breed_score, breed = get_breed_and_score(filename)
    # Update saved values
    saved_breed = breed
    saved_breed_score = breed_score
    saved_lon = lon
    saved_lat = lat
    saved_color = color
    saved_filename = filename

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
        distance = calculate_distance(lat, lon, cat.center['lat'], cat.center['lon'])
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
    target_cats.sort(key=lambda cat : cat[1], reverse=True)

    print target_cats

    # Serialize to JSON string then sends the response back
    jsonify([cat[0].__dict__ for cat in target_cats])
    return 'success'
    
@catify.route('/debug', methods=['GET'])
def debug():
    return json.dumps([cat.__dict__ for cat in cats]) + '\n\n\nbreed: {}'.format(saved_breed) 

if __name__ == '__main__':
    catify.run()
