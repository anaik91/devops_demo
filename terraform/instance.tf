#data "google_compute_instance" "appserver" {
# name = "instance-1"
#  zone = "us-central1-a"
#}


resource "google_compute_instance" "master" {
  name         = "${var.prefix}-vm-master"
  machine_type = "n1-standard-1"
  zone         = "${var.region}-a"

  tags = ["automation", "webapp"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7-v20191014"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    name = "nginx"
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key)}"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
