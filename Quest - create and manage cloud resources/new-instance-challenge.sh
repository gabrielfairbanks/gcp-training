gcloud config set compute/zone us-east1-b
gcloud config set compute/region us-east1

gcloud compute instances create "nucleus-jumphost" \
--machine-type "f1-micro" \
--subnet "default"