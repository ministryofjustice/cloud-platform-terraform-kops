# cloud-platform-terraform-kops

cloud-platform-terraform-kops generates the kops manifest consumed by our kubernetes clusters. To build the manifest we need to include different resources as requirements: subnets, VPC, AZs, cidrs, etc.

## Usage

```hcl
module "kops" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-kops?ref=0.0.1"

  vpc_name                = local.vpc_name
  cluster_domain_name     = trimsuffix(local.cluster_base_domain_name, ".")
  kops_state_store        = data.terraform_remote_state.global.outputs.kops_state_s3_bucket_name[0]
  auth0_client_id         = module.auth0.oidc_kubernetes_client_id
  authorized_keys_manager = module.bastion.authorized_keys_manager

  cluster_node_count       = lookup(var.cluster_node_count, terraform.workspace, var.cluster_node_count["default"])
  master_node_machine_type = lookup(var.master_node_machine_type, terraform.workspace, var.master_node_machine_type["default"])
  worker_node_machine_type = lookup(var.worker_node_machine_type, terraform.workspace, var.worker_node_machine_type["default"])
  enable_large_nodesgroup  = lookup(var.enable_large_nodesgroup, terraform.workspace, var.enable_large_nodesgroup["default"])
  enable_ingress_nodesgroup  = lookup(var.enable_ingress_nodesgroup, terraform.workspace, var.enable_ingress_nodesgroup["default"])

  template_path   = "../../../../kops"
  oidc_issuer_url = "https://${var.auth0_tenant_domain}/"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vpc_name | The vpc_name where the cluster is going to be deployed | string |  | yes |
| cluster_domain_name | The cluster domain used for externalDNS annotations and certmanager | string |  | yes |
| auth0_client_id | Auth0 Client ID (used to authenticate to the cluster) | string | | yes |
| oidc_issuer_url |  | string | `0` | no |
| template_path | Path where the rendered templated is saved, the file is needed by create-cluster.rb script under kops/ folder | string | | yes |
| kops_state_store | The S3 bucket where kops state is going to be saved | string |  | no |
| authorized_keys_manager | The authorized SSH keys that are going to be included in the cluster | string |  | yes |
| cluster_node_count | The number of worker node in the cluster | string | - | no |
| master_node_machine_type | The AWS EC2 instance types to use for master nodes | string | - | no |
| worker_node_machine_type | The AWS EC2 instance types to use for worker nodes | string |  | no |
| enable_large_nodesgroup | Due to Prometheus resource consumption we added a larger node groups (r5.2xlarge), this variable you enable the creation of it | string | `` | no |
| enable_ingress_nodesgroup | Production clusters now have their own dedicated nodes for ingress controllers. By setting this option to true, you will create a dedicated node for ingress | string | `` | no |


## Outputs

No outputs
