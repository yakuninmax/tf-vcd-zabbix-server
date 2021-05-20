output "external-ip" {
  value = var.external_ip != "" ? var.external_ip : data.vcd_edgegateway.edge.external_network_ips[0]
}

output "external-ssh-port" {
  value = var.external_ssh_port != "" ? var.external_ssh_port : random_integer.ssh-port[0].result
}

output "internal-ip" {
  value = vcd_vapp_vm.vm.network[0].ip
}

output "name" {
  value = vcd_vapp_vm.vm.name
}

output "admin-user" {
  value = var.admin_user
}

output "admin-password" {
  value = var.admin_password != "" ? var.admin_password : random_string.admin-password[0].result
}

output "mariadb-root-password" {
  value = var.mariadb_root_password != "" ? var.mariadb_root_password : random_string.mariadb-root-password[0].result
}

output "zabbix-db-password" {
  value = var.zbx_db_password != "" ? var.zbx_db_password : random_string.zbx-db-password[0].result
}