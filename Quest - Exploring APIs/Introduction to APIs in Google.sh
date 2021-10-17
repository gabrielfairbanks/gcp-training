https://jsonlint.com/

nano values.json

{  "name": "fairbanks-bucket",
   "location": "us",
   "storageClass": "multi_regional"
}

https://developers.google.com/oauthplayground/

{
  "access_token": "ya29.a0ARrdaM9GxOfdd6U_jtGqdQzn948CWTa0nqASGvhiTOUx3jmPhZDNTjO1GqEcGNgycZ_o_C3QIQNJPYe_ipZllaNC02PwQZs5mtKNDCJ8nT8wr7qrHatn3Chfekg7sC25dtH-MEYK2E5tMsx6NkNqbFueB4Tq", 
  "scope": "https://www.googleapis.com/auth/devstorage.full_control", 
  "token_type": "Bearer", 
  "expires_in": 3599, 
  "refresh_token": "1//048xaXx3QTthFCgYIARAAGAQSNwF-L9IrvMwO1DuEDIl8fT7hShpMhyjz3n6M4ODRcQz5LlzVvwOUvvM2WgGL3QnOB90g6HX0UF8"
}

export OAUTH2_TOKEN=ya29.a0ARrdaM9GxOfdd6U_jtGqdQzn948CWTa0nqASGvhiTOUx3jmPhZDNTjO1GqEcGNgycZ_o_C3QIQNJPYe_ipZllaNC02PwQZs5mtKNDCJ8nT8wr7qrHatn3Chfekg7sC25dtH-MEYK2E5tMsx6NkNqbFueB4Tq
export PROJECT_ID=qwiklabs-gcp-02-4eac4a60f033

curl -X POST --data-binary @values.json \
    -H "Authorization: Bearer $OAUTH2_TOKEN" \
    -H "Content-Type: application/json" \
    "https://www.googleapis.com/storage/v1/b?project=$PROJECT_ID"

realpath demo-image.png
/home/student_00_81c5734f8ce1/demo-image.png
export OBJECT=/home/student_00_81c5734f8ce1/demo-image.png
export BUCKET_NAME=fairbanks-bucket

curl -X POST --data-binary @$OBJECT \
    -H "Authorization: Bearer $OAUTH2_TOKEN" \
    -H "Content-Type: image/png" \
    "https://www.googleapis.com/upload/storage/v1/b/$BUCKET_NAME/o?uploadType=media&name=demo-image"