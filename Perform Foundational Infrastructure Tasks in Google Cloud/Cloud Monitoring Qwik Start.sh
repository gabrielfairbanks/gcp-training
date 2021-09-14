# install apache
sudo apt-get update
sudo apt-get install apache2 php7.0

#start apache
sudo service apache2 restart

# install monitoring agent
curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
sudo bash add-monitoring-agent-repo.sh

sudo apt-get update
sudo apt-get install stackdriver-agent

# install logging agent
curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
sudo bash add-logging-agent-repo.sh

sudo apt-get update
sudo apt-get install google-fluentd

