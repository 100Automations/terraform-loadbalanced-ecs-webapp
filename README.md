# terraform-loadbalanced-ecs-webapp

Configuration for provisioning AWS cloud resources to run a scalable web server
with an internet-facing load balancer.


## example

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

## inputs
todo

# License
GPL-2.0
