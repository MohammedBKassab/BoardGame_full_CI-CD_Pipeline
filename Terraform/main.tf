resource "tls_private_key" "Servers_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "Servers_key" {
    key_name   = var.key_name
    public_key = tls_private_key.Servers_key.public_key_openssh
}

resource "local_file" "private_key" {
    content  = tls_private_key.Servers_key.private_key_pem
    filename = "./${var.key_name}.pem"
}





# Creating 4 Instances for Jenkins, Nexus, Sonarqube, and Monitoring [CI]
resource "aws_instance" "Instances" {
  count = length(var.Names_Instances)
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.Servers_key.key_name
  vpc_security_group_ids  = [element([aws_security_group.Jenkins_SG.id,
  aws_security_group.Sonar_SG.id,
  aws_security_group.Nexus_SG.id,
  aws_security_group.Monitoring_SG.id], count.index)]
  associate_public_ip_address = true
  root_block_device {
    volume_size           = 30
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
   Name = var.Names_Instances[count.index]
  }
  

  lifecycle {
    create_before_destroy = true
  }
}

# Creating 3 Instances for Kubeadm: 2 worker nodes and 1 master node [CD]
resource "aws_instance" "Kubeadm_Instances" {
  count = length(var.Kubeadm)
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.Servers_key.key_name
  user_data = "${file("kubeadm.sh")}" #-------> kubeadm Installation script
  vpc_security_group_ids = [aws_security_group.Cluster_SG.id]
  associate_public_ip_address = true
  root_block_device {
    volume_size = 30
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = var.Kubeadm[count.index]
  }

  lifecycle {
    create_before_destroy = true
  }
}