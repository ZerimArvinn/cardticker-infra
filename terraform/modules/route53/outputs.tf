output "name_servers" {
  description = "Nameservers for the hosted zone (to provide to the registrar)."
  value       = var.create_zone ? aws_route53_zone.this[0].name_servers : data.aws_route53_zone.existing[0].name_servers
}

output "hosted_zone_id" {
  description = "ID of the hosted zone."
  value       = var.create_zone ? aws_route53_zone.this[0].id : data.aws_route53_zone.existing[0].id
}