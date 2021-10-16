#Create a network
gcloud compute networks create labnet --subnet-mode=custom

# Create a subnet
gcloud compute networks subnets create labnet-sub \
   --network labnet \
   --region us-central1 \
   --range 10.0.0.0/28

# list networks
gcloud compute networks list
gcloud compute networks describe NETWORK_NAME

# list subnets
gcloud compute networks subnets list

# create firewall rules
gcloud compute firewall-rules create labnet-allow-internal \
	--network=labnet \
	--action=ALLOW \
	--rules=icmp,tcp:22 \
	--source-ranges=0.0.0.0/0

# view firewall rules
gcloud compute firewall-rules describe [FIREWALL_RULE_NAME]

#Another network
gcloud compute networks create privatenet --subnet-mode=custom
gcloud compute networks subnets create private-sub \
    --network=privatenet \
    --region=us-central1 \
    --range 10.1.0.0/28
gcloud compute firewall-rules create privatenet-deny \
    --network=privatenet \
    --action=DENY \
    --rules=icmp,tcp:22 \
    --source-ranges=0.0.0.0/0

# list firewall rules
gcloud compute firewall-rules list --sort-by=NETWORK

# create vm insteance
gcloud compute instances create pnet-vm \
--zone=us-central1-c \
--machine-type=n1-standard-1 \
--subnet=private-sub
gcloud compute instances create lnet-vm \
--zone=us-central1-c \
--machine-type=n1-standard-1 \
--subnet=labnet-sub

# list vms
gcloud compute instances list --sort-by=ZONE

student_00_69170afe94ce@cloudshell:~ (qwiklabs-gcp-01-dca5d4530169)$ gcloud compute instances list --sort-by=ZONE
NAME: lnet-vm
ZONE: us-central1-c
MACHINE_TYPE: n1-standard-1
PREEMPTIBLE:
INTERNAL_IP: 10.0.0.2
EXTERNAL_IP: 34.68.78.96
STATUS: RUNNING

NAME: pnet-vm
ZONE: us-central1-c
MACHINE_TYPE: n1-standard-1
PREEMPTIBLE:
INTERNAL_IP: 10.1.0.2
EXTERNAL_IP: 34.136.208.56
STATUS: RUNNING

ping -c 3 34.136.208.56