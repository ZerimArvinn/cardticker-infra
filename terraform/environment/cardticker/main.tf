module "route_53" {
    source = "./../../modules/route53"
    zone_name   = var.zone_name
    create_zone = var.create_zone
}