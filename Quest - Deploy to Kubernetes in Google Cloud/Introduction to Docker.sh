docker run hello-world

docker images

docker ps -a

mkdir test && cd test

cat > Dockerfile <<EOF
# Use an official Node runtime as the parent image
FROM node:6
# Set the working directory in the container to /app
WORKDIR /app
# Copy the current directory contents into the container at /app
ADD . /app
# Make the container's port 80 available to the outside world
EXPOSE 80
# Run app.js using node when the container launches
CMD ["node", "app.js"]
EOF

cat > app.js <<EOF
const http = require('http');
const hostname = '0.0.0.0';
const port = 80;
const server = http.createServer((req, res) => {
    res.statusCode = 200;
      res.setHeader('Content-Type', 'text/plain');
        res.end('Hello World\n');
});
server.listen(port, hostname, () => {
    console.log('Server running at http://%s:%s/', hostname, port);
});
process.on('SIGINT', function() {
    console.log('Caught interrupt signal and will exit');
    process.exit();
});
EOF

docker build -t node-app:0.1 .

docker run -p 4000:80 --name my-app node-app:0.1

docker stop my-app && docker rm my-app

#Run in the background
docker run -p 4000:80 --name my-app -d node-app:0.1
docker ps

docker logs [container_id]

# Opens a terminal on a container
docker exec -it [container_id] bash
docker exec -it b994dbe186d3 bash

# Inspect container metadata
docker inspect [container_id]
docker inspect b994dbe186d3
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' b994dbe186d3

docker tag node-app:0.2 gcr.io/qwiklabs-gcp-04-7cf08c987f83/node-app:0.2

docker push gcr.io/qwiklabs-gcp-04-7cf08c987f83/node-app:0.2

docker stop $(docker ps -q)
docker rm $(docker ps -aq)

docker rmi node-app:0.2 gcr.io/qwiklabs-gcp-04-7cf08c987f83/node-app node-app:0.1
docker rmi node:6
docker rmi $(docker images -aq) # remove remaining images
docker images

docker pull gcr.io/qwiklabs-gcp-04-7cf08c987f83/node-app:0.2
docker run -p 4000:80 -d gcr.io/qwiklabs-gcp-04-7cf08c987f83/node-app:0.2
curl http://localhost:4000