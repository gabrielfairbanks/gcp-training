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

# Task 4: Create and configure Cloud SQL Instance
gcloud sql instances create griffin-dev-db \
    --tier=db-f1-micro \
    --region=us-east1

gcloud sql connect griffin-dev-db --user=root

CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO "wp_user"@"%" IDENTIFIED BY "stormwind_rules";
FLUSH PRIVILEGES;