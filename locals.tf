locals {
  action = var.stop == true ? "Stop" : "Start"
  id = "${var.use_case}-${random_password.id.result}"
}

resource "random_password" "id" {
  length = 8
  special = false
}