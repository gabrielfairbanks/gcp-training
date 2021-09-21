# Create a pub/sub topic
gcloud pubsub topics create myTopic

# List topics
gcloud pubsub topics list

# Create a subscription
gcloud  pubsub subscriptions create --topic myTopic mySubscription

# Publish a message
gcloud pubsub topics publish myTopic --message "Hello"
gcloud pubsub topics publish myTopic --message "Publisher's name is Lord Fairbanks"
gcloud pubsub topics publish myTopic --message "Publisher likes to eat Parmegiana"
gcloud pubsub topics publish myTopic --message "Publisher thinks Pub/Sub is awesome"

# Pull messages
gcloud pubsub subscriptions pull mySubscription --auto-ack