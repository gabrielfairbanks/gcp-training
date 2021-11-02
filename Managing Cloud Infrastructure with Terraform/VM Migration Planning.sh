gcloud iam service-accounts create terraform --display-name terraform
gcloud iam service-accounts list

gcloud iam service-accounts keys create ./credentials.json --iam-account terraform@qwiklabs-gcp-01-f999b2527be3.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding qwiklabs-gcp-01-f999b2527be3 --member=serviceAccount:terraform@qwiklabs-gcp-01-f999b2527be3.iam.gserviceaccount.com --role=roles/owner

gsutil mb gs://qwiklabs-gcp-01-f999b2527be3-state-bucket

gcloud compute instances create build-instance --zone=us-west1-b --machine-type=n1-standard-1 --subnet=my-first-subnet --network-tier=PREMIUM --maintenance-policy=MIGRATE --image=debian-9-stretch-v20190312 --image-project=debian-cloud --boot-disk-size=100GB --boot-disk-type=pd-standard --boot-disk-device-name=build-instance-1 --tags=allow-ssh

gcloud compute ssh build-instance --zone=us-west1-b

sudo apt-get update && sudo apt-get install apache2 -y

gcloud compute instances stop build-instance --zone=us-west1-b
gcloud compute images create apache-one \
  --source-disk build-instance \
  --source-disk-zone us-west1-b \
  --family my-apache-webserver

gcloud compute images describe-from-family my-apache-webserver

terraform destroy