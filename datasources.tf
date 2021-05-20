# Get default vCD org edge info
data "vcd_edgegateway" "edge" {
  filter {
    name_regex = "^.*$"
  }
}

# Get Terraform host external IP
data "http" "terraform-external-ip" {
  url = "https://api.my-ip.io/ip"
}

# Userdata file template (install Zabbix agent)
data "template_file" "userdata" {
  template = file("${path.module}/userdata.yaml")

  vars = {
    admin_user            = "${var.admin_user}"
    admin_password        = var.admin_password != "" ? "${bcrypt(var.admin_password)}" : "${bcrypt(random_string.admin-password[0].result)}"
    mariadb_root_password = var.mariadb_root_password != "" ? "${var.mariadb_root_password}" : "${random_string.mariadb-root-password[0].result}"
    zbx_db_password       = var.zbx_db_password != "" ? "${var.zbx_db_password}" : "${random_string.zbx-db-password[0].result}"
  }
}