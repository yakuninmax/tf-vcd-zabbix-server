provider "vcd" {
  user              = var.vcd_user
  password          = var.vcd_password
  auth_type         = "integrated"
  org               = var.vcd_org
  vdc               = var.vcd_org_vdc
  url               = "${var.vcd_url}/api"
  max_retry_timeout = "60"
}