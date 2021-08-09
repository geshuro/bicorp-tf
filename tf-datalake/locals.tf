locals {
  id                  = var.id == "" ? random_string.id.result : var.id
  data_lake_name      = "${var.project}"
  tags = {
    "Environment"     = var.environment
    "Project"         = var.project
  }
}