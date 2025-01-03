provider "google" {
  project = "inforsec"   # Replace with your GCP project ID
  region  = "us-central1"         # Adjust to your preferred region
  credentials = file("./key.json")
}

# Static External IP
resource "google_compute_address" "static_ip" {
  name   = "compute-instance-ip"
  region = "us-central1"          # Adjust to match your Compute Instance region
}

# Compute Instance
resource "google_compute_instance" "instance" {
  name         = "dns-compute-instance"
  machine_type = "e2-micro"        # Cost-effective option
  zone         = "us-central1-a"  # Adjust to your preferred zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"  # Debian 11 OS
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

    metadata = {
    ssh-keys = <<EOT
        dns:./ssh-key/key.pub
        root:./ssh-key/key1.pub
        EOT
    }
}

# DNS Zone
resource "google_dns_managed_zone" "dns_zone" {
  name        = "dns-zone"
  dns_name    = "informationsecurity.cloud."       # Replace with your domain name
  description = "DNS zone"
}

# A Record in DNS Zone
resource "google_dns_record_set" "a_record" {
  name         = "informationsecurity.cloud."      # Root domain
  type         = "A"
  ttl          = 20
  managed_zone = google_dns_managed_zone.dns_zone.name

  rrdatas = [google_compute_address.static_ip.address]
}

# CNAME Record for www.informationsecurity.cloud
resource "google_dns_record_set" "www_cname" {
  name         = "www.informationsecurity.cloud."  # Subdomain
  type         = "CNAME"
  ttl          = 20                                # Same TTL as the A record
  managed_zone = google_dns_managed_zone.dns_zone.name

  rrdatas = ["informationsecurity.cloud."]         # Points to the root domain
}
