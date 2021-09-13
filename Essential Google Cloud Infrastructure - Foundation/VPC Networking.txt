us-central1 - 10.128.0.0/20
europe-west1 - 10.132.0.0/20

#managementnet creation
gcloud compute networks create managementnet --project=qwiklabs-gcp-02-2372abf780ca --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

gcloud compute networks subnets create managementsubnet-us --project=qwiklabs-gcp-02-2372abf780ca --range=10.130.0.0/20 --network=managementnet --region=us-central1

#privatesubnet creation
gcloud compute networks create privatenet --subnet-mode=custom

gcloud compute networks subnets create privatesubnet-us --range=172.16.0.0/24 --network=privatenet --region=us-central1

gcloud compute networks subnets create privatesubnet-eu --range=172.20.0.0/20 --network=privatenet --region=europe-west1

gcloud compute networks list

# list subnets
gcloud compute networks subnets list --sort-by=NETWORK

# Create firewall rule
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=tcp:22,tcp:3389,icmp --source-ranges=0.0.0.0/0

# Create vm instance
gcloud beta compute --project=qwiklabs-gcp-02-2372abf780ca instances create management-us-vm \
  --zone=us-central1-c \
  --machine-type=f1-micro \
  --subnet=managementsubnet-us \
  --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --service-account=818497817102-compute@developer.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
  --image=debian-10-buster-v20210817 \
  --image-project=debian-cloud \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-balanced \
  --boot-disk-device-name=management-us-vm \
  --no-shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --reservation-affinity=any
  
gcloud beta compute instances create privatenet-us-vm \
  --zone=us-central1-c \
  --machine-type=f1-micro \
  --subnet=privatesubnet-us \
  --image-family=debian-10 \
  --image-project=debian-cloud \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=privatenet-us-vm
