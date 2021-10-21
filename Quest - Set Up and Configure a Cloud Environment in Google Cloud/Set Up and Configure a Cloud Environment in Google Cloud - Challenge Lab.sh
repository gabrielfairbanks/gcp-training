gcloud config set compute/region us-east1
gcloud config set compute/zone us-east1-b

# Task 1: Create development VPC manually
gcloud compute networks create griffin-dev-vpc --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
gcloud compute networks subnets create griffin-dev-wp --range=192.168.16.0/20 --network=griffin-dev-vpc
gcloud compute networks subnets create griffin-dev-mgmt --range=192.168.32.0/20 --network=griffin-dev-vpc

# Task 2: Create production VPC manually
gcloud compute networks create griffin-prod-vpc --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
gcloud compute networks subnets create griffin-prod-wp --range=192.168.48.0/20 --network=griffin-prod-vpc
gcloud compute networks subnets create griffin-prod-mgmt --range=192.168.64.0/20 --network=griffin-prod-vpc

# Task 3: Create bastion host
gcloud compute instances create bastion \
     --machine-type=f1-micro \
     --tags=bastion \
     --network-interface subnet=griffin-dev-mgmt \
     --network-interface subnet=griffin-prod-mgmt

gcloud compute firewall-rules create allow-bastion-dev-ssh --network griffin-dev-vpc --allow tcp:22 --source-ranges=192.168.32.0/20
gcloud compute firewall-rules create allow-bastion-prod-ssh --network griffin-prod-vpc --allow tcp:22 --source-ranges=192.168.64.0/20


# Task 4: Create and configure Cloud SQL Instance
gcloud sql instances create griffin-dev-db \
    --tier=db-f1-micro \
    --region=us-east1

gcloud sql connect griffin-dev-db --user=root

CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO "wp_user"@"%" IDENTIFIED BY "stormwind_rules";
FLUSH PRIVILEGES;

# Task 5: Create Kubernetes cluster
gcloud beta container clusters create griffin-dev \
    --num-nodes=2 \
    --network=griffin-dev-vpc \
    --subnetwork=griffin-dev-wp \
    --zone=us-east1-b

# Task 6: Prepare the Kubernetes cluster
gsutil -m cp -r gs://cloud-training/gsp321/wp-k8s .

kubectl create -f wp-k8s/wp-env.yaml

gcloud iam service-accounts keys create key.json \
    --iam-account=cloud-sql-proxy@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
kubectl create secret generic cloudsql-instance-credentials \
    --from-file key.json

# Task 7: Create a WordPress deployment
kubectl create -f wp-k8s/wp-deployment.yaml
kubectl apply -f wp-k8s/wp-deployment.yaml
kubectl create -f wp-k8s/wp-service.yaml
