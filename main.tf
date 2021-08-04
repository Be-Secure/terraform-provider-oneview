provider "oneview" {
  ov_username   = var.username
  ov_password   = var.password
  ov_endpoint   = var.endpoint
  ov_sslverify  = var.ssl_enabled
  ov_apiversion = 2800
  ov_ifmatch    = "*"
}

data "oneview_ethernet_network" "eth" {
	name = "Auto-Ethernet-1"
}

data "oneview_fc_network" "fc" {
	name = "FC_FA"
}

# Create Logical Interconnect Group
resource "oneview_logical_interconnect_group" "logical_interconnect_group" {
  type                 = "logical-interconnect-groupV8"
  name                 = "Auto-LIG-02"
  interconnect_bay_set = 3
  enclosure_indexes    = [1, 2, 3]
  redundancy_type      = "HighlyAvailable"
  interconnect_map_entry_template {
    enclosure_index        = 1
    bay_number             = 3
    interconnect_type_name = "Virtual Connect SE 40Gb F8 Module for Synergy"
  }
  interconnect_map_entry_template {
    enclosure_index        = 2
    bay_number             = 6
    interconnect_type_name = "Virtual Connect SE 40Gb F8 Module for Synergy"
  }
  interconnect_map_entry_template {
    enclosure_index        = 2
    bay_number             = 3
    interconnect_type_name = "Synergy 20Gb Interconnect Link Module"
  }
  interconnect_map_entry_template {
    enclosure_index        = 3
    bay_number             = 3
    interconnect_type_name = "Synergy 20Gb Interconnect Link Module"
  }
  interconnect_map_entry_template {
    enclosure_index        = 1
    bay_number             = 6
    interconnect_type_name = "Synergy 20Gb Interconnect Link Module"
  }
  interconnect_map_entry_template {
    enclosure_index        = 3
    bay_number             = 6
    interconnect_type_name = "Synergy 20Gb Interconnect Link Module"
  }
  igmp_settings {
    consistency_checking       = "ExactMatch"
    igmp_idle_timeout_interval = 260
    igmp_snooping              = true
    prevent_flooding           = true
    proxy_reporting            = true
  }

  uplink_set {
    ethernet_network_type = "NotApplicable"
    mode                  = "Auto"
    name                  = "UplinkSet2" 
    network_type          = "FibreChannel"
    network_uris          = [
      data.oneview_fc_network.fc.uri, //"/rest/fc-networks/37aae264-8fd5-4624-960d-10173bde5752",
    ]

    logical_port_config {
        bay_num       = 3
        desired_speed = "Auto"
        enclosure_num = 1
        port_num      = 68 
        primary_port  = false 
      }

    logical_port_config {
        bay_num       = 3
        desired_speed = "Auto"
        enclosure_num = 1
        port_num      = 67
        primary_port  = false
      }
  }
  uplink_set {
     ethernet_network_type = "Tagged"
     lacp_timer            = "Short" 
     mode                  = "Auto" 
     name                  = "UplinkSet1"
     network_type          = "Ethernet" 
     network_uris          = [
       data.oneview_ethernet_network.eth.uri, //"/rest/ethernet-networks/64c6034a-811e-4add-b34f-68f941dab50b",
     ] 

     logical_port_config {
          bay_num       = 3 
          desired_speed = "Auto"
          enclosure_num = 1 
          port_num      = 61
          primary_port  = false 
       }
   }
}
