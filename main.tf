# Generate random admin user password if variable "admin_password" not set
resource "random_string" "admin-password" {
  count = var.admin_password == "" ? 1 : 0
  
  length      = 10
  special     = true
  min_numeric = 1
  min_special = 1
  min_lower   = 1
  min_upper   = 1
}

# Generate random Mariadb root password if variable "mariadb_root_password" not set
resource "random_string" "mariadb-root-password" {
  count = var.mariadb_root_password == "" ? 1 : 0
  
  length      = 10
  special     = true
  min_numeric = 1
  min_special = 1
  min_lower   = 1
  min_upper   = 1
}

# Generate random Zabbix db password if variable "zbx_db_password" not set
resource "random_string" "zbx-db-password" {
  count = var.zbx_db_password == "" ? 1 : 0
  
  length      = 10
  special     = true
  min_numeric = 1
  min_special = 1
  min_lower   = 1
  min_upper   = 1
}

# Create VM
resource "vcd_vapp_vm" "vm" {
  vapp_name       = var.vapp
  name            = var.name
  catalog_name    = var.template.catalog
  template_name   = var.template.name
  memory          = var.ram * 1024
  cpus            = var.cpus
  cpu_cores       = var.cores_per_socket
  storage_profile = var.storage_profile != "" ? var.storage_profile : null
  computer_name   = var.name

  override_template_disk {
    size_in_mb  = var.system_disk_size * 1024
    bus_type    = var.system_disk_bus
    bus_number  = 0
    unit_number = 0
  }
  
  dynamic "network" {
    for_each = var.nics
      content {
        type               = "org"
        name               = network.value["network"]
        ip_allocation_mode = network.value["ip"] != "" ? "MANUAL" : "POOL"
        ip                 = network.value["ip"] != "" ? network.value["ip"] : null
      }
  }

  customization {
    enabled                    = true
    allow_local_admin_password = false
    auto_generate_password     = false 
  }

  guest_properties = {
    "instance-id"    = "id-ovf"
    "hostname"       = "${var.name}"
    "user-data"      = "${base64encode(data.template_file.userdata.rendered)}"
  }
}

# Add VM data disks
resource "vcd_vm_internal_disk" "disk" {
  count = length(var.data_disks)
  
  vapp_name       = vcd_vapp_vm.vm.vapp_name
  vm_name         = vcd_vapp_vm.vm.name
  bus_type        = "paravirtual"
  size_in_mb      = var.data_disks[count.index].size * 1024
  bus_number      = 1
  unit_number     = count.index
  storage_profile = var.data_disks[count.index].storage_profile != "" ? var.data_disks[count.index].storage_profile : ""
}

# Insert media
resource "vcd_inserted_media" "media" {
  count      = var.media != null ? 1 : 0
  depends_on = [ vcd_vm_internal_disk.disk ]

  vapp_name   = vcd_vapp_vm.vm.vapp_name
  vm_name     = vcd_vapp_vm.vm.name
  catalog     = var.media.catalog
  name        = var.media.name
  eject_force = true
}

# Get random SSH port
resource "random_integer" "ssh-port" {
  count = var.allow_external_ssh == true ? var.external_ssh_port == "" ? 1 : 0 : 0
  
  min = 40000
  max = 49999
}

# SSH DNAT rule
resource "vcd_nsxv_dnat" "ssh-dnat-rule" {
  count = var.allow_external_ssh == true ? 1 : 0
  
  edge_gateway = data.vcd_edgegateway.edge.name
  network_type = "ext"
  network_name = tolist(data.vcd_edgegateway.edge.external_network)[0].name  

  original_address   = data.vcd_edgegateway.edge.external_network_ips[0]
  original_port      = var.external_ssh_port != "" ? var.external_ssh_port : random_integer.ssh-port[0].result
  translated_address = vcd_vapp_vm.vm.network[0].ip
  translated_port    = "22"
  protocol           = "tcp"

  description = "SSH to ${vcd_vapp_vm.vm.name}"
}

# SSH firewall rule
resource "vcd_nsxv_firewall_rule" "ssh-firewall-rule" {  
  count = var.allow_external_ssh == true ? 1 : 0

  edge_gateway = data.vcd_edgegateway.edge.name
  name         = "SSH to ${vcd_vapp_vm.vm.name}"

  source {
    ip_addresses = [trimspace(data.http.terraform-external-ip.body)]
  }

  destination {
    ip_addresses = [data.vcd_edgegateway.edge.external_network_ips[0]]
  }

  service {
    protocol = "tcp"
    port     = var.external_ssh_port != "" ? var.external_ssh_port : random_integer.ssh-port[0].result
  }
}