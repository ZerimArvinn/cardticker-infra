resource "aws_route53_zone" "this" {
  count = var.create_zone ? 1 : 0

  name          = var.zone_name
  comment       = var.comment
  force_destroy = var.force_destroy
  tags          = var.tags
}

# If not creating the zone, look up existing by name (public zone)
data "aws_route53_zone" "existing" {
  count        = var.create_zone ? 0 : 1
  name         = var.zone_name
  private_zone = false
}