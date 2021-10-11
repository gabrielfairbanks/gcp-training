gcloud config set project qwiklabs-gcp-01-04ba2f9af7fb
gcloud config set project qwiklabs-gcp-04-f8df6449dd65

gcloud compute networks create network-a --subnet-mode custom

gcloud compute networks subnets create network-a-central --network network-a \
    --range 10.0.0.0/16 --region us-central1

gcloud compute instances create vm-a --zone us-central1-a --network network-a --subnet network-a-central

gcloud compute firewall-rules create network-a-fw --network network-a --allow tcp:22,icmp

gcloud compute routes list --project qwiklabs-gcp-04-f8df6449dd65

10.8.0.2