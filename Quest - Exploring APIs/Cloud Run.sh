gcloud services enable run.googleapis.com
mkdir helloworld-nodejs
cd helloworld-nodejs

cat > package.json <<EOF
{
  "name": "cloudrun-helloworld",
  "version": "1.0.0",
  "description": "Simple hello world sample in Node",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "author": "",
  "license": "Apache-2.0",
  "dependencies": {
    "express": "^4.16.4"
  }
}
EOF

cat > index.js <<EOF
const express = require('express');
const app = express();
app.get('/', (req, res) => {
  console.log('Hello world received a request.');
  const target = process.env.TARGET || 'World';
  res.send(`Hello ${target}!`);
});
const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log('Hello world listening on port', port);
});
EOF

cat > Dockerfile <<EOF
# Use the official Node.js 10 image.
# https://hub.docker.com/_/node
FROM node:10
# Create and change to the app directory.
WORKDIR /usr/src/app
# Copy application dependency manifests to the container image.
# A wildcard is used to ensure both package.json AND package-lock.json are copied.
# Copying this separately prevents re-running npm install on every code change.
COPY package*.json ./
# Install production dependencies.
RUN npm install --only=production
# Copy local code to the container image.
COPY . .
# Run the web service on container startup.
CMD [ "npm", "start" ]
EOF

gcloud builds submit --tag gcr.io/qwiklabs-gcp-02-bf7912d7cafd/helloworld

docker run -d -p 8080:8080 gcr.io/qwiklabs-gcp-02-bf7912d7cafd/helloworld

gcloud beta run deploy --image gcr.io/qwiklabs-gcp-02-bf7912d7cafd/helloworld --max-instances=2