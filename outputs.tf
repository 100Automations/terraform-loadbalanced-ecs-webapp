output cluster_name {
  description = "Name of the cluster"
  value       = aws_ecs_cluster.cluster.name
}

output ecs_service_security_group_id {
  description = "The security group id for the ECS service"
  value       = aws_security_group.svc_sg.id
}

output lb_dns_name {
  description = "The hostname generated for the load balancer"
  value       = aws_lb.alb.dns_name
}

output lb_arn {
  description = "The ARN for the load balancer"
  value       = aws_lb.alb.arn
}

output service_id {
  description = "The id for the ecs service"
  value       = aws_ecs_service.svc.id
}

output service_name {
  description = "The name of the ecs service"
  value       = aws_ecs_service.svc.name
}

output service_iam_role {
  description = "The iam role for the ecs service"
  value       = aws_ecs_service.svc.iam_role
}

output service_desired_count {
  description = "The number of tasks desired running under the service"
  value       = aws_ecs_service.svc.desired_count
}

output task_exec_role_arn {
  description = "The role ARN for the task execution role"
  value       = aws_iam_role.task_exec_role.arn
}

output lb_target_group_name {
  description = "The name of the target group pointed to by the ALB"
  value       = aws_lb_target_group.default.name
}

output task_definition_vars {
  description = "The interpolated vars passed into the task defintion template"
  value       = data.template_file.task_definition.vars
}

output task_definition_rendered {
  description = "The fully rendered task definition json file"
  value       = data.template_file.task_definition.rendered
}
