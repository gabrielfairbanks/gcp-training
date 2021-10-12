gcloud config set compute/zone us-east1-d

git clone https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git

cd continuous-deployment-on-kubernetes

# Install Kubernetes
gcloud container clusters create jenkins-cd \
--num-nodes 2 \
--machine-type n1-standard-2 \
--scopes "https://www.googleapis.com/auth/source.read_write,cloud-platform"

gcloud container clusters list

gcloud container clusters get-credentials jenkins-cd

kubectl cluster-info

# Setup Helm
helm repo add jenkins https://charts.jenkins.io
helm repo update

gsutil cp gs://spls/gsp330/values.yaml jenkins/values.yaml
helm install cd jenkins/jenkins -f jenkins/values.yaml --wait

kubectl get pods

#Configure the Jenkins service account to be able to deploy to the cluster.
kubectl create clusterrolebinding jenkins-deploy --clusterrole=cluster-admin --serviceaccount=default:cd-jenkins

# Run the following command to setup port forwarding to the Jenkins UI from the Cloud Shell
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=cd" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &

printf $(kubectl get secret cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
F6x4U4Kc0miI6QqriWfG3J

# Create kubernetes namespace
kubectl create ns production

kubectl apply -f k8s/production -n production
kubectl apply -f k8s/canary -n production
kubectl apply -f k8s/services -n production

kubectl scale deployment gceme-frontend-production -n production --replicas 4

kubectl get pods -n production -l app=gceme -l role=frontend
kubectl get pods -n production -l app=gceme -l role=backend

kubectl get service gceme-frontend -n production
35.231.122.221

export FRONTEND_SERVICE_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=production services gceme-frontend)

# Creating pipeline
gcloud source repos create default
git init
git config credential.helper gcloud.sh
git remote add origin https://source.developers.google.com/p/$DEVSHELL_PROJECT_ID/r/default
git config --global user.email "gabriel.fairbanks@gmail.com"
git config --global user.name "Gabriel Fairbanks"
git add .
git commit -m "Initial commit"
git push origin master

https://source.developers.google.com/p/qwiklabs-gcp-01-264a2874db8a/r/default

git add Jenkinsfile html.go main.go
git commit -m "Version 2.0.0"
git push origin new-feature

kubectl proxy &

curl \
http://localhost:8001/api/v1/namespaces/new-feature/services/gceme-frontend:80/proxy/version

# Canary
git checkout -b canary
git push origin canary

export FRONTEND_SERVICE_IP=$(kubectl get -o \
jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=production services gceme-frontend)
while true; do curl http://$FRONTEND_SERVICE_IP/version; sleep 1; done

# Production
git checkout master
git merge canary
git push origin master
