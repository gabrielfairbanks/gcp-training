# Create new network
gcloud compute networks create managementnet --project=qwiklabs-gcp-04-5121b1cc8423 --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

gcloud compute networks subnets create managementsubnet-us --project=qwiklabs-gcp-04-5121b1cc8423 --range=10.130.0.0/20 --network=managementnet --region=us-central1

# Create privatenet network
gcloud compute networks create privatenet --subnet-mode=custom

#Create privatenet subnet
#US
gcloud compute networks subnets create privatesubnet-us --network=privatenet --region=us-central1 --range=172.16.0.0/24
#EU
gcloud compute networks subnets create privatesubnet-eu --network=privatenet --region=europe-west4 --range=172.20.0.0/20

#list networks
gcloud compute networks list

#create firewall rules
gcloud compute firewall-rules create privatenet-allow-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=privatenet --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

# create vm instance
gcloud compute instances create privatenet-us-vm --zone=us-central1-f --machine-type=n1-standard-1 --subnet=privatesubnet-us

#IPs
mynet-eu-vm 35.204.100.0
managementnet-us-vm 34.72.81.158
privatenet-us-vm 35.232.169.126