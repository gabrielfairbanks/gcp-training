git clone https://github.com/GoogleCloudPlatform/training-data-analyst
cd training-data-analyst/blogs

PROJECT_ID=`gcloud config get-value project`
BUCKET=${PROJECT_ID}-bucket
gsutil mb -c multi_regional gs://${BUCKET}

gsutil -m cp -r endpointslambda gs://${BUCKET}
gsutil ls gs://${BUCKET}/*

mv endpointslambda/Apache2_0License.txt endpointslambda/old.txt
rm endpointslambda/aeflex-endpoints/app.yaml
gsutil -m rsync -d -r endpointslambda gs://${BUCKET}/endpointslambda
gsutil ls gs://${BUCKET}/*

gsutil -m acl set -R -a public-read gs://${BUCKET}

http://storage.googleapis.com/qwiklabs-gcp-00-be44e87738b0-bucket/endpointslambda/old.txt

gsutil cp -s nearline ghcn/ghcn_on_bq.ipynb gs://${BUCKET}
gsutil ls -Lr gs://${BUCKET} | more

gsutil rm -rf gs://${BUCKET}/*
gsutil rb gs://${BUCKET}


