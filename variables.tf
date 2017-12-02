variable "profile" {
  type        = "string"
  description = "AWS profile name"
}

variable "region" {
  type        = "string"
  description = "Region of the resources"
}

variable "cidr_block" {
  type        = "string"
  description = "CIDR block from vpc"
  default     = "10.99.0.0/16"
}

variable "namespace" {
  type        = "string"
  description = "namespace of the all solution"
  default     = "demo-deves"
}

variable "instance_type" {
  type        = "string"
  description = "type of instance"
  default     = "t2.micro"
}

variable "ami_id" {
  type        = "string"
  description = "id of ami"
  default     = "ami-bf4193c7"
}

variable "key_name" {
  type        = "string"
  description = "name of aws key for direct access"
  default     = "claytonsilva"
}

variable "cluster_size" {
  type        = "string"
  description = "size of the cluster"
  default     = "3"
}
