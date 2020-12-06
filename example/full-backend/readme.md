# example: full backend
This example creates a full backend infrastructure including:
- VPC
- RDS instance running PostgreSQL
- secure bastion host
- Application load balancer (ALB)
- A webserver running the given task defintion on an ECS cluster
- Cloudwatch logs group where the ECS task application logs will go to
- An SSL certificate signed for "myapp.com" that permits the app to serve traffic over HTTPS :star:

# prerequisites
This configuration assumes a few things exist in order to run successfully. 
1. the terraform user has appropriate permissions assigned and local tools installed and setup.
2. the account this is running in has a Route53 hosted zone and DNS routing configured.
