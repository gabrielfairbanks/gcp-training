wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip
unzip terraform_0.13.0_linux_amd64.zip 
sudo mv terraform /usr/local/bin/
terraform -v

gsutil -m cp -r gs://spls/gsp233/* .
cd tf-gke-k8s-service-lb

terraform show