gcloud config set compute/zone us-central1-a
gcloud beta container clusters create private-cluster \
    --enable-private-nodes \
    --master-ipv4-cidr 172.16.0.16/28 \
    --enable-ip-alias \
    --create-subnetwork ""

gcloud compute networks subnets list --network default

gcloud compute networks subnets describe gke-private-cluster-subnet-137f1198 --region us-central1

gcloud compute instances create source-instance --zone us-central1-a --scopes 'https://www.googleapis.com/auth/cloud-platform'

gcloud compute instances describe source-instance --zone us-central1-a | grep natIP

natIP: 34.133.153.6

gcloud container clusters update private-cluster \
    --enable-master-authorized-networks \
    --master-authorized-networks 34.133.153.6/32

gcloud compute ssh source-instance --zone us-central1-a

gcloud components install kubectl

gcloud container clusters get-credentials private-cluster --zone us-central1-a

kubectl get nodes --output yaml | grep -A4 addresses

kubectl get nodes --output wide

gcloud container clusters delete private-cluster --zone us-central1-a

gcloud compute networks subnets create my-subnet \
    --network default \
    --range 10.0.4.0/22 \
    --enable-private-ip-google-access \
    --region us-central1 \
    --secondary-range my-svc-range=10.0.32.0/20,my-pod-range=10.4.0.0/14

gcloud beta container clusters create private-cluster2 \
    --enable-private-nodes \
    --enable-ip-alias \
    --master-ipv4-cidr 172.16.0.32/28 \
    --subnetwork my-subnet \
    --services-secondary-range-name my-svc-range \
    --cluster-secondary-range-name my-pod-range

gcloud container clusters update private-cluster2 \
    --enable-master-authorized-networks \
    --master-authorized-networks 34.133.153.6/32

gcloud compute ssh source-instance --zone us-central1-a

gcloud container clusters get-credentials private-cluster2 --zone us-central1-a

kubectl get nodes --output yaml | grep -A4 addresses