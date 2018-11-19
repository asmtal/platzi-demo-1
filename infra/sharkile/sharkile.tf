# Firewalls
resource "digitalocean_firewall" "admin" {
  name = "fw-admin"

  tags = ["${digitalocean_tag.admin.name}"]

  inbound_rule = [
    {
      # SSH
      protocol = "tcp"
      port_range = "22"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      # SFTP
      protocol = "tcp"
      port_range = "2222"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]

  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "udp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "icmp"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]
}

resource "digitalocean_firewall" "web" {
  name = "fw-web"

  tags = ["${digitalocean_tag.traccar.name}", "${digitalocean_tag.web.name}"]

  inbound_rule = [
    {
      # HTTP
      protocol = "tcp"
      port_range = "80"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      # HTTPS
      protocol = "tcp"
      port_range = "443"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]

  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "udp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "icmp"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]
}

resource "digitalocean_firewall" "traccar" {
  name = "fw-traccar"

  tags = ["${digitalocean_tag.traccar.name}"]

  inbound_rule = [
    # GPS devices
    {
      protocol           = "tcp"
      port_range         = "5001"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "5002"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "5006"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "5013"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "5020"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "5023"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "5036"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "5040"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "5055"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "5082"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "5093"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "8000"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol           = "tcp"
      port_range         = "8082"
      source_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]

  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "udp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "icmp"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]
}

# Tags
resource "digitalocean_tag" "admin" {
  name = "admin"
}

resource "digitalocean_tag" "web" {
  name = "web"
}

resource "digitalocean_tag" "traccar" {
  name = "traccar"
}

# Droplets
resource "digitalocean_droplet" "traccar" {
  image  = "31734516"
  name   = "sharkile.xyz"
  region = "sfo1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [1720439]
  tags = ["${digitalocean_tag.traccar.name}",
    "${digitalocean_tag.web.name}",
    "${digitalocean_tag.admin.name}"]
  lifecycle {
    ignore_changes = "*"
  }
}

# Domains
resource "digitalocean_domain" "avisosenlineacom" {
    name = "avisosenlinea.com"
    ip_address = "${digitalocean_droplet.traccar.ipv4_address}"
}

resource "digitalocean_domain" "sharkilexyz" {
    name = "sharkile.xyz"
    ip_address = "${digitalocean_droplet.traccar.ipv4_address}"
}

resource "digitalocean_domain" "simplegpstrackcom" {
    name = "simplegpstrack.com"
    ip_address = "${digitalocean_droplet.traccar.ipv4_address}"
}

resource "digitalocean_domain" "spaonalimx" {
    name = "spaonali.mx"
}

resource "digitalocean_domain" "tgrupogardeacom" {
    name = "tgrupogardea.com"
    ip_address = "${digitalocean_droplet.traccar.ipv4_address}"
}

# Add records
resource "digitalocean_record" "avisosenlinea-ns1" {
    domain = ${digitalocean_domain.avisosenlineacom.name}
    type = "NS"
    name = "@"
    value = "ns1.digitalocean.com"
}

resource "digitalocean_record" "avisosenlinea-ns2" {
    domain = ${digitalocean_domain.avisosenlineacom.name}
    type = "NS"
    name = "@"
    value = "ns2.digitalocean.com"
}

resource "digitalocean_record" "avisosenlinea-ns3" {
    domain = ${digitalocean_domain.avisosenlineacom.name}
    type = "NS"
    name = "@"
    value = "ns3.digitalocean.com"
}

resource "digitalocean_record" "avisosenlinea-host" {
    domain = ${digitalocean_domain.avisosenlineacom.name}
    type = "A"
    name = "@"
    value = "104.236.167.72"
}

resource "digitalocean_record" "avisosenlinea-ns1" {
    domain = ${digitalocean_domain.avisosenlineacom.name}
    type = "TXT"
    name = "notifications"
    value = "v=spf1 include:mailgun.org ~all"
}
