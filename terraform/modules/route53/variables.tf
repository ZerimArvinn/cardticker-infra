variable "zone_name" {
  description = "The DNS zone name (e.g. example.com)."
  type        = string
}

variable "create_zone" {
  description = "Whether to create a new Route53 hosted zone. If false, module will look up an existing zone by name."
  type        = bool
  default     = true
}

variable "comment" {
  description = "Optional comment for the hosted zone."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Whether to allow the hosted zone to be destroyed even if it contains records."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to apply to the hosted zone."
  type        = map(string)
  default     = {}
}