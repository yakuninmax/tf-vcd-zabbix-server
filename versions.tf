terraform {

  required_providers {
    vcd = {
      source  = "vmware/vcd"
      version = ">= 3.3.0"
    }
  }

  required_version = ">= 1.0.0"
}
