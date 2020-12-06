locals {
  # some shared values
  region = "us-west-2"
  namespace = "hfla"
  stage = "dev"
  project_name = "city-api"
}

# this example creates a VPC, RDS instance running a PostgreSQL database using another module, as well as a webserver app using this module.
module "networked_rds" {
  source = "git::https://github.com/100Automations/terraform-aws-postgres-vpc.git?ref=tags/v0.3.3"

  project_name = local.project_name
  stage = local.stage
  region = local.region
  account_id = "0123456789"

  ssh_public_key_names = ["alice", "bob", "carol"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  db_username = "mya"
  db_name = "ballotnavdb"
  # here we pull the database password from an existing secret in SSM Param Store, referenced in the data resource above
  # read more about SSM, Systems Manager param store for safely storing application secrets here: https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html
  db_password = data.aws_ssm_parameter.db_password.value
}

module "webserver" {
  source = "git::https://github.com/100Automations/terraform-loadbalanced-ecs-webapp.git?ref=tags/v0.1.0"

  project_name = local.project_name
  task_name = "api-server"
  container_name = "server"
  # this port is EXPOSE in the application Dockerfile and target by the load balancer
  container_port = 8080
  container_cpu = 256
  container_memory = 2048 # Nodejs will like A LOT of RAM!
  desired_count = 1
  extra_task_definition_vars = {
    disable_auto_migrations = "true"
    polling_interval = "300"
  }

  task_definition_file = "myapp-task-defintion.json"

  acm_certificate_arn = module.cert.this_acm_certificate_arn
  public_subnet_ids = module.networked_rds.public_subnet_ids

  namespace = local.namespace
  stage = local.stage
  region = local.region
}

# we declare the AWS provider and region we are working in
provider "aws" {
  region  = local.region
}

# references an existing parameter in SSM called "DB_PASSWORD" stored under the path of /dev/us-west-2/myapp
data aws_ssm_parameter "db_password" {
  name = "/dev/us-west-2/myapp/DB_PASSWORD"
}

# creates an SSL certificate with the domain of my app. This is required by the load balancer to server
# HTTPS traffic.
module "cert" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-acm.git?ref=tags/v2.11.0"
  zone_id = data.aws_route53_zone.zone.hosted_zone_id
  domain_name = "api.myapp.com"
  subject_alternative_names = ["*.myapp.com"]
}

# reference to the Route53 DNS zone in this account.
data aws_route53_zone "zone" {
  name = "myapp.com."
}
