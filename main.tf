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

resource "google_compute_firewall" "firewallExt" {
  name    = "firewall-ext"
  network = "default"

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

# Compute Instance
resource "google_compute_instance" "instance" {
  name         = "dns-compute-instance"
  machine_type = "e2-medium"        # Cost-effective option
  zone         = "us-central1-a"  # Adjust to your preferred zone
  allow_stopping_for_update = true       

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
        dns:${file("./ssh-key/key.pub")}
        root:${file("./ssh-key/key1.pub")}
        EOT
    }
}
