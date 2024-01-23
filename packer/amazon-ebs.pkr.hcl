source "amazon-ebs" "rhel" {
  instance_type = "t2.micro"
  region        = "us-west-2"

  source_ami_filter {
    filters = {
      name                = "RHEL-9.0.0_HVM-20220513-x86_64-0-Hourly2-GP2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["309956199498"]
  }

  ssh_username = "ec2-user"
  tags = {
    "Name"        = "unir-tarea-mean"
    "Environment" = "Production"
    "OS_Version"  = "RHEL 9"
    "Release"     = "Latest"
    "Created-by"  = "Carlos Colón"
  }
}

source "amazon-ebs" "ubuntu" {
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  tags = {
    "Name"        = "unir-tarea-mean"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu 20.04"
    "Release"     = "Latest"
    "Created-by"  = "Carlos Colón"
  }
}