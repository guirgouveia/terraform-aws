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
    max_unavailable            = 1
    max_unavailable_percentage = 0
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

# Define the IAM role for the EKS cluster and node group
resource "aws_iam_role" "main" {
  name = "${var.cluster_name}-eks"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["eks.amazonaws.com", "ec2.amazonaws.com"]
        }
      }
    ]
  })
}

# Define the IAM policy for the EKS worker nodes
resource "aws_iam_policy" "main_worker_nodes" {
  name = "${var.cluster_name}-eks-worker-nodes"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVpcs",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:CreateNodegroup",
          "eks:DeleteNodegroup",
          "eks:UpdateNodegroupConfig",
          "eks:UpdateNodegroupVersion",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Define the IAM policy for the EKS cluster and node group
resource "aws_iam_policy" "main" {
  name = "${var.cluster_name}-eks"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVpcs",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:CreateNodegroup",
          "eks:DeleteNodegroup",
          "eks:UpdateNodegroupConfig",
          "eks:UpdateNodegroupVersion",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "eks:CreateFargateProfile",
          "eks:DeleteFargateProfile",
          "eks:DescribeFargateProfile",
          "eks:ListFargateProfiles",
          "eks:UpdateFargateProfile",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "eks:CreateCluster",
          "eks:DeleteCluster",
          "eks:DescribeUpdate",
          "eks:ListUpdates",
          "eks:UpdateClusterConfig",
          "eks:UpdateClusterVersion",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "eks:TagResource",
          "eks:UntagResource",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "eks:AssociateEncryptionConfig",
          "eks:CreateAddon",
          "eks:DeleteAddon",
          "eks:DescribeAddon",
          "eks:ListAddons",
          "eks:UpdateAddon",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "eks:CreateNodegroup",
          "eks:DeleteNodegroup",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:UpdateNodegroupConfig",
          "eks:UpdateNodegroupVersion",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "eks:CreateFargateProfile",
          "eks:DeleteFargateProfile",
          "eks:DescribeFargateProfile",
          "eks:ListFargateProfiles",
          "eks:UpdateFargateProfile",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "eks:CreateCluster",
          "eks:DeleteCluster",
          "eks:DescribeUpdate",
          "eks:ListUpdates",
          "eks:UpdateClusterConfig",
          "eks:UpdateClusterVersion",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "eks:TagResource",
          "eks:UntagResource",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Attach the IAM policy to the IAM role
resource "aws_iam_role_policy_attachment" "main" {
  policy_arn = aws_iam_policy.main.arn
  role       = aws_iam_role.main.name
}

# Define the IAM policy attachment for the EKS worker nodes
resource "aws_iam_role_policy_attachment" "main_worker_nodes" {
  policy_arn = aws_iam_policy.main_worker_nodes.arn
  role       = aws_iam_role.main.name
}