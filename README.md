# terraform-loadbalanced-ecs-webapp

Configuration for provisioning AWS cloud resources to run a scalable web server
with an internet-facing load balancer.

You might use this if to deploy a containerized webserver application. This
module plays well with [100Automations
postgres-vpc](https://github.com/100automations/terraform-aws-postgres-vpc) for
deploying a full secure backend with database, network, and web server.


# example
```hcl
module "webapp" {
  source = "git::https://github.com/100Automations/terraform-loadbalanced-ecs-webapp.git?ref=tags/v0.1.0"

  # common
  tags       = { Namespace = "OneHundredAutomations", terraform_managed = true }
  namespace  = "1ha"
  region     = "us-west-2"
  stage      = "dev"

  acm_certificate_arn = "arn:aws:acm:us-west-2:123456789100:certificate/ac4akjde-asdjf44444asdlkfj463464fbe5"
  vpc_id = "vpc-01234556abcdef"

  task_definition_file = "task.json"

  public_subnet_ids = [
    "subnet-0011223",
    "subnet-002233445",
    "subnet-0033aabbcce",
  ]

  project_name     = "my-webapp"
  task_name        = "server"
  container_name   = "express"
  container_port   = 80
  container_cpu    = 256
  container_memory = 1024
  desired_count    = 1
  extra_task_definition_vars = { foo = "bar", another = "baz" }
}
```

see the [example directory](./example) for a more full fledged working example.

# inputs
| Name | Description |  Default | Required |
|------|-------------|----------|:--------:|
|additional\_security\_group\_ids|a list of 0 or more security group ids to be added to ecs service network configuraiton. Example ['sg-abcd10234', 'sg-112233445']| []| no|
|stage|a short name identifier describing the stage or lifecycle this infra represents. Example "dev", "stg", "qa", "prod"| ""| yes|
|namespace|a short name identifier for top-level organization of resources. Used to separate and identify different projects and avoid name collisions on shared infra| "" | yes|
|region| AWS region short code where the infrastructure is running. Example: "us-west-2", "us-east-1"| "us-west-2"| no|
|project\_name| A name or identifier of the project. Used for naming cluster,service, security groups, and more.| ""| yes|
|vpc\_id| The VPC identifier for which the app should be provisioned into|""|yes|
|container\_name| The name of the webserver container|""|yes|
|container\_port| The port that the container exposes to web traffic|8080|no|
|container\_memory| The amount of RAM in MiB to dedicate to the container|1024|no|
|container\_cpu|The amount of cpu in MiB to dedicate to the container|512|no|
|desired\_count|The number of tasks to be launched when the service is created|1|no|
|assign\_public\_ip| Whether or not to expose a public IP address on the task containers. Can be useful for debugging when true. Defaults to false.|false|no|
|tags| Map of resource tags useful for billing breakdown and usage|{terraform\_managed = true}|no|
|acm\_certificate\_arn| the ARN for the TLS certificate available in the region where the webserver is to be running| ""| yes|
|health\_check\_route| The endpoint on the webserver app where the load balancer target group will do HTTP GET requests to run health checks. Must return an HTTP status 200| "/status"| no|
|task\_name|The name of the ECS task; can match the project or container name. This value is useful to know and often important for CI actions doing automated deployments|"app"|no|
|extra\_task\_definition\_vars|A map of key value pairs to be passed into an interpolated into the task defintion template json file. These work hand in hand with the `task.json` file described below.| {}| no|
|task\_definition\_file|The file path to a JSON file containing an ECS task definition. This file is expected to be within the current working directory. Read more on ECS task defintion syntax: https://docs.aws amazon.com/AmazonECS/latest/developerguide/example\_task\_definitions.html|"task\_definition.json"|no|

# License
GPL-2.0
