variable "AWS_REGION" {
    type = string
    default = "eu-west-2"
}

variable "AMIS" {

    type = map(string)
    default = {
        "eu-west-1" = "ami-06e7b0bfe14ece2dd"
        "eu-west-2" = "ami-0edaf73facca4214c"
        "us-east-1" = "ami-09b4f17f4df57bbf2"
}

}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "barista-eks-cluster"
}

variable "instance_type" {
  description = "EC2 instance type for the node group"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired number of nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 4
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  default    = "400675223919"
}
