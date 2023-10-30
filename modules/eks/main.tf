# Define the EKS cluster resource
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.main.arn

  # Define the VPC configuration for the EKS cluster
  # Makes sure to keep the EKS cluster private
  vpc_config {
    subnet_ids              = var.subnets
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.main,
    aws_iam_role_policy_attachment.main_worker_nodes,
  ]

  tags = var.tags
}

# Define the EKS node group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.main.arn
  subnet_ids      = var.subnets

  instance_types = var.node_group_instance_type != "" ? [var.node_group_instance_type] : null

  scaling_config {
    desired_size = var.scaling_config.desired_size
    max_size     = var.scaling_config.max_size
    min_size     = var.scaling_config.min_size
  }

  update_config {
    max_unavailable_percentage = 50
  }

  depends_on = [
    aws_iam_role_policy_attachment.main_worker_nodes,
  ]
}

# Define the SSH key pair for the EKS node group instances
resource "aws_key_pair" "main" {
  key_name   = "${var.cluster_name}-eks"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Define the security group for the EKS node group instances
resource "aws_security_group" "main" {
  name_prefix = "${var.cluster_name}-eks"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}