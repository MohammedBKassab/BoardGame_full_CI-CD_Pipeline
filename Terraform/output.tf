output "instance_public_ips" {
  description = "Public IPs of the created EC2 instances"
  value       = aws_instance.Instances[*].public_ip
}

output "Cluster_public_ip" {
  description = "Public IPs of the created EC2 instances"
  value       = aws_instance.Kubeadm_Instances[*].public_ip
  
}


output "security_group_ids" {
  value = [
    aws_security_group.Jenkins_SG.id,
    aws_security_group.Sonar_SG.id,
    aws_security_group.Nexus_SG.id,
    aws_security_group.Monitoring_SG.id,
    aws_security_group.Cluster_SG.id
  ]
}

