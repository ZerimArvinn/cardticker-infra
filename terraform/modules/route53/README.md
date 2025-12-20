# Route53 Module

This module creates (or looks up) a Route53 hosted zone and exposes the nameservers and hosted zone id as outputs.

Inputs
- `zone_name` (string) - zone name (e.g. example.com)
- `create_zone` (bool) - whether to create a new hosted zone (default: true)
- `comment` (string) - optional comment for the zone
- `force_destroy` (bool) - allow destroying zones with records
- `tags` (map) - tags to apply

Outputs
- `name_servers` - list of nameservers for the hosted zone
- `hosted_zone_id` - hosted zone ID

Example usage

```hcl
module "dns" {
  source    = "../modules/route53"
  zone_name = "example.com"
  # create_zone = false # set to false to use an existing zone
}

output "ns" {
  value = module.dns.name_servers
}
```