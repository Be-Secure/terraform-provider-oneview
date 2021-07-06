provider "oneview" {
  ov_username =   "${var.username}"
  ov_password =   "${var.password}"
  ov_endpoint =   "${var.endpoint}"
  ov_sslverify =  "${var.ssl_enabled}"
  ov_apiversion = 3000
  ov_ifmatch = "*"
}

# Fetching Logical Interconnect
data "oneview_logical_interconnect" "logical_interconnect" {
        name = "Auto-LE-Auto-LIG"
}

# Fetching Network
data "oneview_ethernet_network" "ethernetnetwork" {
  name = "Auto-Ethernet-1"
}

data "oneview_uplink_set" "ups" {
  name= "Auto-UplinkSet"
}

# Updates Uplink Set
resource "oneview_uplink_set" "UplinkSet" {
  name                     = "Auto-UplinkSet-Updated"
  type                     = "uplink-setV7"
  uri			   = "${data.oneview_uplink_set.ups.uri}"
  logical_interconnect_uri = "${data.oneview_logical_interconnect.logical_interconnect.uri}"
  network_uris             = ["${data.oneview_ethernet_network.ethernetnetwork.uri}",]
  fc_network_uris          = []
  fcoe_network_uris        = []
  port_config_infos 	   = []
  manual_login_redistribution_state = "NotSupported"
  connection_mode                   = "Auto"
  network_type                      = "Ethernet"
  ethernet_network_type             = "Tagged"
}
