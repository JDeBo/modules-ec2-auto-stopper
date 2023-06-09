variable "use_case" {
  description = "Unique identifier for the use case the EC2 instances are created for. (Must be CamelCase)"
}

variable "ec2_map" {
  description = "Map of ec2 instances to associate to the lambda"
}

variable "stop" {
  type = bool
  description = "whether the module should be starting or stopping the instance"
  default = true
}

variable "cron_schedule" {
  type = string
  description = "Cron schedule for running stop action. Eg. 0 5 * * ? *"
  default = "0 5 * * ? *"
}