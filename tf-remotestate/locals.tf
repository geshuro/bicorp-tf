locals {
  tfstate_name        = "${var.project}tfstate"
  tags = {
    "Environment"     = var.environment
    "Project"         = var.project
  }
}