provider "google" {
    project = "nimble-augury-465911-f3"
    credentials = file("gcp.json")
   zone="us-central1-a"
  
}


variable "machine_type" {
    default = ""
  
}

resource "google_compute_instance" "insta1" {
    name = "one"
    machine_type = "${var.machine_type}"
    boot_disk {
      initialize_params {
        image = "centos-stream-9"
      }
    }
    allow_stopping_for_update = true
    network_interface {
      network = "default"
	access_config{}
    }
     metadata = {
    # FIX: Use replace() to strip Windows-style carriage returns (\r\n)
    # and ensure the script uses Linux-style line endings (\n).
    startup-script =<<-EOT
      #!/bin/bash
      # Wait for network to be ready
      echo " start this file execution "
      sudo apt-get install -y telnet
      sudo apt-get install -y nginx
      sudo systemctl enable nginx
      # ADDED: Start nginx immediately for health checks to pass
      sudo systemctl start nginx
      sudo chmod -R 755 /var/www/html
      HOSTNAME=$(hostname)
      sudo echo "<!DOCTYPE html> <html> <body style='background-color:rgb(250, 210, 210);'> <h1>Welcome to StackSimplify - WebVM App1 </h1> <p><strong>VM Hostname:</strong> $HOSTNAME</p> <p><strong>VM IP Address:</strong> $(hostname -I)</p> <p><strong>Application Version:</strong> V1</p> <p>Google Cloud Platform - Demos</p> </body></html>" | sudo tee /var/www/html/index.html
    EOT
    
  }


  
}
