# Creating privatenet
gcloud compute networks create privatenet  --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional 
gcloud compute networks subnets create privatenet-us  --range=10.130.0.0/20 --network=privatenet --region=us-central1

# conecting to instance via ssh and iap tunnel
gcloud compute ssh vm-internal --zone us-central1-c --tunnel-through-iap

#Refresh packages
sudo apt-get update