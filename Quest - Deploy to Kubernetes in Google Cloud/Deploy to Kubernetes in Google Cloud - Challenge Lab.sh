gcloud config set compute/zone us-east1-b

#Create a Docker image and store the Dockerfile.
source <(gsutil cat gs://cloud-training/gsp318/marking/setup_marking.sh)

gcloud source repos clone valkyrie-app --project=qwiklabs-gcp-01-f3e1f8d12464

cd valkyrie-app/

cat > Dockerfile <<EOF
FROM golang:1.10
WORKDIR /go/src/app
COPY source .
RUN go install -v
ENTRYPOINT ["app","-single=true","-port=8080"]
EOF

docker build -t valkyrie-app:v0.0.1 .

step1.sh

#Test the created Docker image.
docker run -p 8080:8080 --name valkyrie-app valkyrie-app:v0.0.1 &

step2.sh

#Push the Docker image into the Container Repository.
docker tag valkyrie-app:v0.0.1 gcr.io/$DEVSHELL_PROJECT_ID/valkyrie-app:v0.0.1
docker push gcr.io/$DEVSHELL_PROJECT_ID/valkyrie-app:v0.0.1



#Use the image to create and expose a deployment in Kubernetes
gcloud container clusters get-credentials valkyrie-dev --region us-east1-d

nano k8s/deployment.yaml
nano k8s/service.yaml
gcr.io/qwiklabs-gcp-01-f3e1f8d12464/valkyrie-app:v0.0.1

kubectl create -f k8s/deployment.yaml
kubectl create -f k8s/service.yaml


#Update the image and push a change to the deployment.
kubectl scale deployment valkyrie-dev --replicas 3
git checkout master
git merge origin/kurt-dev
git push origin master

docker build -t valkyrie-app:v0.0.2 .
docker tag valkyrie-app:v0.0.2 gcr.io/$DEVSHELL_PROJECT_ID/valkyrie-app:v0.0.2
docker push gcr.io/$DEVSHELL_PROJECT_ID/valkyrie-app:v0.0.2

git config --global user.email "gabriel.fairbanks@gmail.com"
git config --global user.name "Gabriel Fairbanks"


#Create a pipeline in Jenkins to deploy a new version of your image when the source code changes
printf $(kubectl get secret cd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo

export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=cd" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:8080 >> /dev/null &


j4LapHXyyu9XP9irvwBRaz

git clone https://source.developers.google.com/p/qwiklabs-gcp-01-f3e1f8d12464/r/valkyrie-app