# Deploy a cloud function
gcloud functions deploy helloWorld \
  --stage-bucket fairbanks-cf-bucket \
  --trigger-topic hello_world \
  --runtime nodejs8

# Check if cloud function is available
gcloud functions describe helloWorld

# Trigger the function
DATA=$(printf 'Hello World!'|base64) && gcloud functions call helloWorld --data '{"data":"'$DATA'"}'

# Check cloud function logs
gcloud functions logs read helloWorld