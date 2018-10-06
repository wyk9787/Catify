from cats_data import *

def add_new_cat(name, color, breed, lon, lat):
    id = len(all_cats);
    new_cat = Cat(id, name, color, breed, lon, lat)
    #all_cats.append(new_cat)

add_new_cat("coco", "white", "Mixed", 200, 100)
