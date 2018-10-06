from cats_data import *
from flask import Flask

app = Flask(__name__)
@app.route('/confirm', methods=['POST'])
def confirm_cat(url, id, lon, lat):
    all_cats[id].add_location_and_image(lon, lat) # Adding a new location to the cat's info
    print "Confirm_cat: Success"

#confirm_cat("", 0, 200, 100)
#print all_cats[0].location[0]
