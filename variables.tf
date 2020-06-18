variable "vpc_name" {
  description = "The vpc_name where the cluster is going to be deployed"
  type        = string
}

variable "cluster_domain_name" {
  description = "The cluster domain used for externalDNS annotations and certmanager"
  type = string
}

variable "auth0_client_id" {
  description = ""
  type = string
}

variable "oidc_issuer_url" {}

variable "template_path" {
  type = string
  description = "Path where the rendered templated is saved, the file is needed by create-cluster.rb script under kops/ folder"
}

variable "kops_state_store" {
  type = string
  description = "The S3 bucket where kops state is going to be saved"
}

variable "authorized_keys_manager" {
  description = "The authorized SSH keys that are going to be included in the cluster" 
}

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
