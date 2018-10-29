import sys

from google.cloud import automl_v1beta1
from google.cloud.automl_v1beta1.proto import service_pb2

project_id = 'catify-218805'
model_id = 'ICN5060689131880883161'

# A helper function to test if the credentials are set properly
def implicit():
    from google.cloud import storage
    storage_client = storage.Client()
    buckets = list(storage_client.list_buckets())                             
    print(buckets)

def get_breed_and_score(filename):
    breed_str = str(get_breed_string(filename)) 
    if breed_str == '':
        print 'Warning: did not receive breed and its score from cloud' 
        return 0, 'None'
    parse_lists = breed_str.split(' ')

    # Parse score
    score = float(parse_lists[9])

    # Parse breed
    breed_ele = parse_lists[-1]
    breed = breed_ele[breed_ele.find('"') + 1 : breed_ele.rfind('"')]

    return score, breed

def get_breed_string(filename):
  with open(filename, 'rb') as ff:
    content = ff.read()

  # credentials = service_account.Credentials.from_service_account_file("/home/Garrett/credential.json")
  # prediction_client = automl_v1beta1.PredictionServiceClient(credentials=credentials) 
  prediction_client = automl_v1beta1.PredictionServiceClient(KeyFilename="/home/Garrett/credential.json") 

  name = 'projects/{}/locations/us-central1/models/{}'.format(project_id, model_id)
  payload = {'image': {'image_bytes': content }}
  params = {}
  request = prediction_client.predict(name, payload, params)
  return request  # waits till request is returned

print get_breed_and_score("cat.JPG")
# implicit()
