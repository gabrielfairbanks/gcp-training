#Create bucket
gsutil mb gs://<BUCKET_NAME>

# Copy file to bucket
gsutil cp [MY_FILE] gs://[BUCKET_NAME]


# List regions
gcloud compute regions list