# Add a load loadbalancer with tag
resource "digitalocean_loadbalancer" "platzi-demo" {
  name = "platzi-html-v2"
  region = "nyc3"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 3000
    target_protocol = "http"
  }

  healthcheck {
    port = 3000
    protocol = "http"
    path = "/"
  }

  droplet_tag = "${digitalocean_tag.platzi-demo.name}"
}

# Create a new tag
resource "digitalocean_tag" "platzi-demo" {
  name = "platzi-html"
}

# Create a new Web Droplet in the nyc3 region
resource "digitalocean_droplet" "platzi-demo" {
  count = 3
  image  = "${var.image_id}"
  name   = "platzi-demo-v2"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = [1720439]
  tags = ["${digitalocean_tag.platzi-demo.id}"]
  lifecycle {
    create_before_destroy = true
  }
  provisioner "name" {
    command = "sleep 160 && curl ${self.ipv4_address}:3000"
  }
  user_data = <<EOF
#cloud-config
coreos:
  units:
    - name: "platzi.service"
      command: "start"
      content: |
        [Unit]
        Description=Platzi Demo
        After=docker.service

        [Service]
        ExecStart=/usr/bin/docker run -d -p 3000:3000 platzi
EOF
}
