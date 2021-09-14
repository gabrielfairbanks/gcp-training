gcloud config set compute/zone us-east1-b
gcloud config set compute/region us-east1

#Creates startup file
cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF

# Create an instance template.
gcloud compute instance-templates create nucleus-lb-backend-template \
   --metadata-from-file startup-script=startup.sh

# Create a target pool
gcloud compute target-pools create nucleus-www-pool \
    --region us-east1

# Create a managed instance group.
gcloud compute instance-groups managed create nucleus-lb-backend-group \
   --base-instance-name nginx \
   --template=nucleus-lb-backend-template \
   --size=2 \
   --target-pool nucleus-www-pool

# Create a firewall rule to allow traffic (80/tcp).
gcloud compute firewall-rules create nucleus-www-firewall \
    --allow tcp:80
	
gcloud compute forwarding-rules create nucleus-nginx-lb \
--region us-east1 \
--ports=80 \
--target-pool nucleus-www-pool

# Create a health check.
gcloud compute http-health-checks create http-basic-check --global

gcloud compute instance-groups managed \
set-named-ports nucleus-lb-backend-group \
--named-ports http:80


# Creating a backend service
gcloud compute backend-services create nucleus-web-backend-service \
        --protocol=HTTP \
        --http-health-checks=http-basic-check \
        --global

# Adding the instance group as backend of the backend service
gcloud compute backend-services add-backend nucleus-web-backend-service \
        --instance-group=nucleus-lb-backend-group \
        --instance-group-zone=us-east1-b \
        --global

# Map incoming requests to web-backed service
gcloud compute url-maps create nucleus-web-map-http \
        --default-service nucleus-web-backend-service 

# Creating http proxy
gcloud compute target-http-proxies create nucleus-http-lb-proxy \
        --url-map nucleus-web-map-http 

# Creating a fowarding rule
gcloud compute forwarding-rules create nucleus-http-content-rule \
        --global \
        --target-http-proxy=nucleus-http-lb-proxy \
        --ports=80
		
gcloud compute forwarding-rules delete nucleus-http-content-rule --global
gcloud compute target-http-proxies delete nucleus-http-lb-proxy
gcloud compute url-maps delete nucleus-web-map-http
gcloud compute backend-services delete nucleus-web-backend-service --global
gcloud compute health-checks delete http nucleus-http-basic-check 
gcloud compute firewall-rules delete nucleus-www-firewall
gcloud compute instance-groups managed delete nucleus-lb-backend-group
gcloud compute target-pools delete nucleus-www-pool
gcloud compute http-health-checks delete http-basic-check
gcloud compute instance-templates delete nucleus-lb-backend-template





		
		
			