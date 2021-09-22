For the firewall rules, make sure:

    - The bastion host does not have a public IP address.
    - You can only SSH to the bastion and only via IAP.
    - You can only SSH to juice-shop via the bastion.
    - Only HTTP is open to the world for juice-shop.

For IAP setup:
    - allow ingress trafic from 35.235.240.0/20
    - enable TCP 22


1- Check the firewall rules. Remove the overly permissive rules.
Deleted open-access firewall rule

2- Navigate to Compute Engine in the Cloud Console and identify the bastion host. The instance should be stopped. Start the instance.
Started bastion vm

3- The bastion host is the one machine authorized to receive external SSH traffic. Create a firewall rule that allows SSH (tcp/22) from the IAP service. The firewall rule should be enabled on bastion via a network tag.
gcloud compute instances add-tags bastion --zone us-central1-b --tags bastion
gcloud compute firewall-rules create allow-ingress-from-iap --direction=INGRESS --priority=1000 --network=acme-vpc --action=ALLOW --rules=tcp:22 --source-ranges=35.235.240.0/20 --target-tags=bastion

4- The juice-shop server serves HTTP traffic. Create a firewall rule that allows traffic on HTTP (tcp/80) to any address. The firewall rule should be enabled on juice-shop via a network tag.
gcloud compute firewall-rules create allow-ingress-http --direction=INGRESS --priority=1000 --network=acme-vpc --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
gcloud compute instances add-tags juice-shop --zone us-central1-b --tags http-server

5 - You need to connect to juice-shop from the bastion using SSH. Create a firewall rule that allows traffic on SSH (tcp/22) from acme-mgmt-subnet network address. The firewall rule should be enabled on juice-shop via a network tag.
gcloud compute firewall-rules create allow-ingress-ssh --direction=INGRESS --priority=1000 --network=acme-vpc --action=ALLOW --rules=tcp:22 --source-ranges=192.168.10.0/24 --target-tags=http-server

6- In the Compute Engine instances page, click the SSH button for the bastion host. Once connected, SSH to juice-shop.
ssh juice-shop
