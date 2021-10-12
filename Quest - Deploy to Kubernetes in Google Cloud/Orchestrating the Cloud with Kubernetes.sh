gcloud config set compute/zone us-central1-b

gcloud container clusters create io

# Creates a deployment
kubectl create deployment nginx --image=nginx:1.10.0

# List pods
kubectl get pods

# Expose to outside the cluster
kubectl expose deployment nginx --port 80 --type LoadBalancer

# List services
kubectl get services

curl http://34.134.44.29:80

cat pods/monolith.yaml

kubectl create -f pods/monolith.yaml

kubectl describe pods monolith

kubectl port-forward monolith 10080:80

TOKEN=$(curl http://127.0.0.1:10080/login -u user|jq -r '.token')

curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:10080/secure

kubectl logs monolith

kubectl exec monolith --stdin --tty -c monolith /bin/sh

kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf
kubectl create -f pods/secure-monolith.yaml

gcloud compute firewall-rules create allow-monolith-nodeport \
  --allow=tcp:31000

curl -k https://34.132.8.78:31000

kubectl get pods -l "app=monolith"
kubectl get pods -l "app=monolith,secure=enabled"

kubectl label pods secure-monolith 'secure=enabled'
kubectl get pods secure-monolith --show-labels

kubectl describe services monolith | grep Endpoints

## Breaking monolith into microservices
kubectl create -f deployments/auth.yaml
kubectl create -f services/auth.yaml

kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml

kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml


curl -k https://35.223.214.113