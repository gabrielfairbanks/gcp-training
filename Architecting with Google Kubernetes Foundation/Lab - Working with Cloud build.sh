nano quickstart.sh
#!/bin/sh
echo "Hello, world! The time is $(date)."

nano Dockerfile
FROM alpine
COPY quickstart.sh /
CMD ["/quickstart.sh"]

chmod +x quickstart.sh

gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/quickstart-image .

git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s
cd ~/ak8s/Cloud_Build/a

gcloud builds submit --config cloudbuild.yaml .