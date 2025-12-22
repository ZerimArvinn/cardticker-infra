variable "zone_name" {
  description = "The DNS zone name (e.g. example.com)."
  type        = string
}

variable "create_zone" {
  description = "Whether to create a new Route53 hosted zone. If false, module will look up an existing zone by name."
  type        = bool
  default     = true
}