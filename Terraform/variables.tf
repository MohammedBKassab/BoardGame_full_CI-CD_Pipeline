variable "key_name" {
    type = string
    default = "Servers_key"
}

variable "ami_id" {
    type = string
    default = "ami-04b4f1a9cf54c11d0"
}

variable "instance_type" {
    type = string
    default = "t2.medium"
}

variable "Names_Instances" {
    type = list(string)
    default = ["Jenkins","Sonarqube","Nexus","monitoring"]
}

variable "SG_list" {
    type = set(string)
    default = [ 
"Jenkins_SG",
"Sonar_SG",
"Nexus_SG",
"Monitoring_SG"
    ]
}



variable "Cluster_SG" {
    type = string
    default = "Cluster_SG"
  
}

variable "Kubeadm" {
    type = list(string)
    default = ["Master", "Worker1", "Worker2"]
}