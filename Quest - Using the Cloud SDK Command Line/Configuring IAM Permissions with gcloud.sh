# install gcloud
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# configure gcloud
gcloud init

#list gcloud components
gcloud components list
gcloud components install beta

# creating a compute instance
gcloud compute instances create lab-1

# check current gcloud config
gcloud config list

gcloud compute zones list
gcloud config set compute/zone us-central1-c

#default configuration is stored in ~/.config/gcloud/configurations/config_default
cat ~/.config/gcloud/configurations/config_default

#Create a new configuration
gcloud init

#change back to the original configuration
gcloud config configurations activate default

# view all roles
gcloud iam roles list | grep "name:"
gcloud iam roles describe roles/compute.instanceAdmin

# switch to user2 config
gcloud config configurations activate user2

echo "export PROJECTID2=qwiklabs-gcp-02-dfdee84beb10" >> ~/.bashrc
. ~/.bashrc
gcloud config set project $PROJECTID2

sudo yum -y install epel-release
sudo yum -y install jq

echo "export USERID2=student-03-e21bdd8ec1e8@qwiklabs.net" >> ~/.bashrc
. ~/.bashrc
gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=roles/viewer

gcloud config configurations activate user2
gcloud config set project $PROJECTID2
gcloud compute instances list
gcloud compute instances create lab-2

gcloud config configurations activate default
gcloud iam roles create devops --project $PROJECTID2 --permissions "compute.instances.create,compute.instances.delete,compute.instances.start,compute.instances.stop,compute.instances.update,compute.disks.create,compute.subnetworks.use,compute.subnetworks.useExternalIp,compute.instances.setMetadata,compute.instances.setServiceAccount"
gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=projects/$PROJECTID2/roles/devops

gcloud config configurations activate user2
gcloud compute instances create lab-2
gcloud compute instances list

# creating a service account
gcloud config configurations activate default
gcloud config set project $PROJECTID2
gcloud iam service-accounts create devops --display-name devops

gcloud iam service-accounts list  --filter "displayName=devops"
[student-01-69542ee8fd3a@centos-clean ~]$ gcloud iam service-accounts list  --filter "displayName=devops"
DISPLAY NAME  EMAIL                                                        DISABLED
devops        devops@qwiklabs-gcp-02-dfdee84beb10.iam.gserviceaccount.com  False

SA=$(gcloud iam service-accounts list --format="value(email)" --filter "displayName=devops")
gcloud projects add-iam-policy-binding $PROJECTID2 --member serviceAccount:$SA --role=roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding $PROJECTID2 --member serviceAccount:$SA --role=roles/compute.instanceAdmin

# creates an instance with service account attached
gcloud compute instances create lab-3 --service-account $SA --scopes "https://www.googleapis.com/auth/compute"