gcloud container clusters create nucleus-cluster 
gcloud container clusters get-credentials nucleus-cluster
kubectl create deployment nucleus-hello-server --image=gcr.io/google-samples/hello-app:2.0 
kubectl expose deployment nucleus-hello-server --type=LoadBalancer --port 8080
kubectl get service