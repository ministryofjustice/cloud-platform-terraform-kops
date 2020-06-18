variable "vpc_name" {}

variable "cluster_base_domain_name" {}

variable "auth0_client_id" {}

variable "kops_state_store" {
    type = string
}
variable "authorized_keys_manager" {}
variable "oidc_issuer_url" {}

variable "cluster_node_count" {
  description = "The number of worker node in the cluster"
  default     = "3"
}

variable "master_node_machine_type" {
  description = "The AWS EC2 instance types to use for master nodes"
  default     = "c4.4xlarge"
}

variable "worker_node_machine_type" {
  description = "The AWS EC2 instance types to use for worker nodes"
  default     = "r5.xlarge"
}

variable "enable_large_nodesgroup" {
  description = "Due to Prometheus resource consumption we added a larger node groups (r5.2xlarge), this variable you enable the creation of it"
  type        = bool
  default     = true
}
