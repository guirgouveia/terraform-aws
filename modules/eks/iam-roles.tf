

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