variable additional_security_group_ids {
  type        = list(string)
  description = "a list of 0 or more security group ids to be added to ecs service network configuraiton. Example ['sg-abcd10234', 'sg-112233445']"
  default     = []
}

variable stage {}
variable namespace {}
variable region {
  description = "AWS region short name where infrastructure is deployed"
  default     = "us-west-2"
}

variable project_name {
  description = "A short name or identifier of the project to be used as a tag and name across resources. Example: 'foodoasis', 'fola', 'ballotnav', 'bn', 'vrms'"
}

variable vpc_id {
  description = "The VPC identifier for which the app should be provisioned into"
}

variable container_port {
  description = "The port number that the app EXPOSES on the container"
  default     = 8080
}

variable container_memory {
  description = "The amount of RAM to declare in for use by the task container"
  default     = 1024
}

variable container_cpu {
  description = "The amount of CPU to declare in for use by the task container"
  default     = 512
}

variable desired_count {
  description = "The number of tasks to launch under the service. Default to 1"
  default     = 1
}

variable assign_public_ip {
  type        = bool
  description = "Should assign a public ip to the service"
  default     = false
}

variable tags {
  type        = map
  description = "Map of resource tags used for identifiers in billing breakdown"
  default     = { terraform_managed = true }
}

variable public_subnet_ids {
  type        = list(string)
  description = "a list of public subnet ids"
}

variable acm_certificate_arn {
  description = "the ARN for the TLS certificate available in the region where the webserver is to be running"
}

variable health_check_route {
  description = "the endpoint where the load balancer target group should hit to run health checks. Must return an HTTP status 200"
  default     = "/status"
}

variable container_name {
  description = "the name of the webservers container"
  default     = "app"
}

variable task_name {
  description = "The name of webserver ECS task"
  default     = "app"
}

variable extra_task_definition_vars {
  type        = map
  description = "key value pair of strings to pass as vars into the task definition template file"
  default     = {}
}

variable task_definition_file {
  description = "The file path to a JSON file containing an ECS task definition. This file is expected to be within the current working directory. Read more on ECS task defintion syntax: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/example_task_definitions.html"
  default     = "task_definition.json"
}
