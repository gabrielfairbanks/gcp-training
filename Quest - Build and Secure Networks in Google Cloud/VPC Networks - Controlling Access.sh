#install nginx
sudo apt-get install nginx-light -y

#Update page
sudo nano /var/www/html/index.nginx-debian.html

# create a test vm
gcloud compute instances create test-vm --machine-type=f1-micro --subnet=default --zone=us-central1-a

#grant access to account via key json
gcloud auth activate-service-account --key-file credentials.json

#list firewall rules
gcloud compute firewall-rules list

# delete firewall rule
gcloud compute firewall-rules delete allow-http-web-server