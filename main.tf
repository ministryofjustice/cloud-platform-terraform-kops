
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "private_a" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "eu-west-2a"

  tags = {
    SubnetType = "Private"
  }
}

data "aws_subnet" "private_b" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "eu-west-2b"

  tags = {
    SubnetType = "Private"
  }
}

data "aws_subnet" "private_c" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "eu-west-2c"

  tags = {
    SubnetType = "Private"
  }
}

data "aws_subnet" "public_a" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "eu-west-2a"

  tags = {
    SubnetType = "Utility"
  }
}

data "aws_subnet" "public_b" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "eu-west-2b"

  tags = {
    SubnetType = "Utility"
  }
}

data "aws_subnet" "public_c" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "eu-west-2c"

  tags = {
    SubnetType = "Utility"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    SubnetType = "Private"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    SubnetType = "Utility"
  }
}

resource "local_file" "kops" {
  filename = "${var.template_path}/${terraform.workspace}.yaml"

  content = templatefile("${path.module}/templates/kops.yaml.tpl", {
    cluster_domain_name                  = var.cluster_domain_name
    cluster_node_count_a                 = var.cluster_node_count_a
    cluster_node_count_b                 = var.cluster_node_count_b
    cluster_node_count_c                 = var.cluster_node_count_c
    kops_state_store                     = var.kops_state_store
    oidc_issuer_url                      = var.oidc_issuer_url
    oidc_client_id                       = var.auth0_client_id
    network_cidr_block                   = data.aws_vpc.selected.cidr_block
    network_id                           = data.aws_vpc.selected.id
    internal_subnets_id_a                = data.aws_subnet.private_a.id
    internal_subnets_id_b                = data.aws_subnet.private_b.id
    internal_subnets_id_c                = data.aws_subnet.private_c.id
    external_subnets_id_a                = data.aws_subnet.public_a.id
    external_subnets_id_b                = data.aws_subnet.public_b.id
    external_subnets_id_c                = data.aws_subnet.public_c.id
    authorized_keys_manager_systemd_unit = indent(6, var.authorized_keys_manager)
    kms_key                              = aws_kms_key.kms.arn
    worker_node_machine_type             = var.worker_node_machine_type
    master_node_machine_type             = var.master_node_machine_type
    enable_large_nodesgroup              = var.enable_large_nodesgroup
    enable_ingress_nodesgroup            = var.enable_ingress_nodesgroup
  })
}

resource "aws_kms_key" "kms" {
  description = "Creates KMS key for etcd volume encryption"
}

