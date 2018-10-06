import importlib

moduleName = 'cats_data'
importlib.import_module(moduleName)

def comfirm_cat(url, id, longitude, latitude):
    print "Testing confirm cat"
