import sys

from google.cloud import automl_v1beta1
from google.cloud.automl_v1beta1.proto import service_pb2

breed_project = 'catbreedrecognizer'
model_id = 'ICN3968837639531152817'

def get_breed(file_path, project_id, model_id):
  with open(file_path, 'rb') as ff:
    content = ff.read()

  prediction_client = automl_v1beta1.PredictionServiceClient()

  name = 'projects/{}/locations/us-central1/models/{}'.format(project_id, model_id)
  payload = {'image': {'image_bytes': content }}
  params = {}
  request = prediction_client.predict(name, payload, params)
  return request  # waits till request is returned

if __name__ == '__main__':
    print get_breed('cat.JPG', breed_project, model_id)


#export GOOGLE_APPLICATION_CREDENTIALS="/Users/arthurhero/Desktop/Catify/CatBreedRecognizer-c7f6c9bd98ac.json"
