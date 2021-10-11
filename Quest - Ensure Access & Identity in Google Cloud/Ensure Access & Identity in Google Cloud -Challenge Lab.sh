# Task 1: Create a custom security role.
gcloud iam roles create orca_storage_update \
--project $DEVSHELL_PROJECT_ID \
--title "Role Orca Storage Editor" --description "Edit Buckets" \
--permissions storage.buckets.get,storage.objects.get,storage.objects.list,storage.objects.update,storage.objects.create \
--stage ALPHA

# Task 2: Create a service account.
gcloud iam service-accounts create orca-private-cluster-sa --display-name "my service account"

# Task 3: Bind a custom security role to a service account.
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:orca-private-cluster-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
    --role roles/monitoring.viewer

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:orca-private-cluster-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
    --role roles/monitoring.metricWriter

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:orca-private-cluster-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
    --role roles/logging.logWriter

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --member serviceAccount:orca-private-cluster-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
    --role projects/qwiklabs-gcp-03-5573e2089b29/roles/orca_storage_update

# Task 4: Create and configure a new Kubernetes Engine private cluster
gcloud config set compute/zone us-east1-b 
gcloud beta container clusters create orca-test-cluster \
    --network orca-build-vpc \
    --subnetwork orca-build-subnet \
    --service-account orca-private-cluster-sa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
    --enable-master-authorized-networks \
    --enable-ip-alias \
    --enable-private-nodes \
    --enable-private-endpoint \
    --master-ipv4-cidr 172.16.0.32/28

gcloud compute instances describe orca-jumphost --zone us-east1-b | grep natIP

gcloud container clusters update orca-test-cluster \
    --enable-master-authorized-networks \
    --master-authorized-networks 192.168.10.2/32

# Task 5: Deploy an application to a private Kubernetes Engine cluster.
gcloud components install kubectl
gcloud config set compute/zone us-east1-b 
gcloud container clusters get-credentials orca-test-cluster --internal-ip --zone=us-east1-b

kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
