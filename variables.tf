variable "admin_password" {
  type        = string
  description = "Admin user password"
  default     = ""
}

variable "admin_user" {
  type        = string
  description = "Admin user name"
  default     = "administrator"
}

variable "allow_external_ssh" {
  type        = bool
  description = "Allow external SSH connections"
  default     = true
}

variable "cores_per_socket" {
  type        = number
  description = "Number of cores per socket"
  default     = 1
}

variable "cpus" {
  type        = number
  description = "Number of virtual CPUs"
  default     = 2
}

variable "data_disks" {
  type = list(object({
    mount_point     = string
    file_system     = string
    storage_profile = string
    size            = number
  }))

  description = "VM hard drives"
  default     = []
}

variable "external_ip" {
  type        = string
  description = "VM external IP address"
  default     = ""
}

variable "external_ssh_port" {
  type        = string
  description = "External SSH port"
  default     = ""
}

variable "mariadb_root_password" {
  type        = string
  description = "Mariadb root password"
  default     = ""
}

variable "media" {
  type = object({
    catalog = string
    name    = string
  })

  default     = null
  description = "Media for VM CD/DVD drive"
}

variable "name" {
  type        = string
  description = "VM name"
  default     = "zbx01"
}

variable "nics" {
  type = list(object({
    network        = string
    ip             = string
  }))

  description = "VM NICs"  
}

variable "ram" {
  type        = number
  description = "Memory amount in gigabytes"
  default     = 8
}

variable "storage_profile" {
  type        = string
  description = "VM storage profile"
  default     = ""
}

variable "system_disk_size" {
  type        = number
  description = "VM system disk size in gigabytes"
  default     = 20
}

variable "system_disk_bus" {
  type        = string
  description = "VM system disk bus type"
  default     = "paravirtual"
}

variable "template" {
  type = object({
    catalog = string
    name    = string
  })
  
  description = "Ubuntu cloud image"
}

variable "vapp" {
  type        = string
  description = "vAPP name"
}

variable "vcd_org" {
  type        = string
  description = "vCD Org name"
}

variable "vcd_org_vdc" {
  type        = string
  description = "vCD Org VDC name"
}

variable "vcd_password" {
  type        = string
  description = "vCD Org Admin password"
}

variable "vcd_url" {
  type        = string
  description = "vCD URL"
}

variable "vcd_user" {
  type        = string
  description = "vCD Org Admin user"
}

variable "zbx_db_password" {
  type        = string
  description = "Zabbix database password"
  default     = ""
}