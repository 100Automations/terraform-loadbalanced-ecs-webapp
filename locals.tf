locals {
  svc_name = substr("${var.stage}-${var.project_name}", 0, 12)
}
