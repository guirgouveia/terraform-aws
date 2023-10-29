<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Project Name](#project-name)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Quick Start](#quick-start)
    - [Requirements and Version Constraints](#requirements-and-version-constraints)
    - [Authentication and Configuration](#authentication-and-configuration)
    - [Terraform State File Locking with S3 and DynamoDB](#terraform-state-file-locking-with-s3-and-dynamodb)
    - [Networking](#networking)
    - [Variables](#variables)
    - [Get Started](#get-started)
    - [Inputs](#inputs)
    - [Outputs](#outputs)
  - [Future Improvements](#future-improvements)
  - [Suggestions](#suggestions)
  - [Reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Project Name

## Table of Contents

- [Introduction](#introduction)
- [Quick Start](#quick-start)
- [Inputs and Outputs](#inputs-and-outputs)
- [Reference](#reference)

## Introduction

This project aims to create an Elastic Kubernetes Cluster (EKS) in AWS using Infrastructure as Code with Terraform. It contains two modules, one for network related resources and one for the EKS and its dependencies. We are following the AWS Well-Architected Framework to ensure that our infrastructure is secure, reliable, efficient, and cost-effective.

The [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) is a set of best practices and guidelines for designing and operating reliable, secure, efficient, and cost-effective systems in the cloud. It provides a consistent approach for customers and partners to evaluate architectures, and provides guidance to help implement designs that will scale with your application needs over time.

## Quick Start

### Requirements and Version Constraints

To use this project, you will need to have the following prerequisites:

- **Terraform** ( version 1.62 )
- **AWS CLI** ( version 2 or later)
- **S3 bucket** for Terraform state file
- **Dynamo Table** for Terraform state file locking

Read the following section about [Terraform State File Locking with S3 and DynamoDB](#terraform-state-file-locking-with-s3-and-dynamodb) to learn how to create them.

### Authentication and Configuration

Before you can deploy the services, you will need to authenticate with AWS. The easiest way is configuring your AWS credentials using the AWS CLI with `aws configure`. For more information, see the [AWS CLI documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).

Further methods of authentication can be found at [Authentication and Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration). For example, you can provide environment variables or a shared credentials file path when running automated pipelines.

Furthermore, you can uncomment the aws provider section in the [backend.tf](./backend.tf) file and provide values for the variables either directly or as environment variables. Notice that, in this case, you'll need to generate a [session token](https://docs.aws.amazon.com/cli/latest/reference/sts/get-session-token.html#examples) if you are using MFA.

### Terraform State File Locking with S3 and DynamoDB

To prevent conflicts when working in a team, we are using the Terraform S3 backend to store the state file remotely in an Amazon S3 bucket with versioning enabled. Read about Terraform state file at the [state file documentation](https://developer.hashicorp.com/terraform/language/state).

We are also using a DynamoDB table for locking to ensure that only one person can make changes to a resource at a time, preventing conflicts and ensuring that changes are applied in the correct order.

To create them, run the script `create-backend.sh` in the `scripts` folder.

You will need to change the values of the variables in the script to match your environment, or declare them as environment variables.

Read more about state file locking with S3 at [the S3 backend documentation](https://developer.hashicorp.com/terraform/language/settings/backends/s3).

### Networking

The cluster spans two Availability Zones and uses two subnets, one in each Availability Zone. The subnets are private and are not exposed to the internet. The EKS cluster is deployed in the private subnets and the endpoint is only exposed internally.

Hence, the EKS cluster is not exposed to the internet. Instead, we are using a NAT Gateway to allow the EKS cluster to access the internet for updates and other dependencies.

### Variables

This project includes default values for all variables, so no variable input is necessary to follow this exact example. 

However, you can change the values of the variables to customize the resources name, instance types, etc.

### Get Started

To get started, having all the prerequisites set, run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

To destroy the resources, run the following command:

```bash
terraform destroy
```

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_name | The name of the EKS cluster. | `string` | `"example-eks-cluster"` | No |
| vpc_id | The ID of the VPC where the EKS cluster will be created. | `string` | `"example-vpc-id"` | No |
| subnets | A list of subnet IDs where the EKS cluster will be created. | `list(string)` | `["example-subnet-id-1", "example-subnet-id-2"]` | No |
| tags | A map of tags to apply to all resources. | `map(string)` | `{}` | No |
| node_group_name | The name of the EKS node group. | `string` | `"example-node-group"` | No |
| node_group_instance_type | The instance type for the EKS node group. | `string` | `"t3.medium"` | No |

### Outputs

| Name | Description |
|------|-------------|
| kubeconfig | The kubectl configuration for the EKS cluster. |
| config_map_aws_auth | The ConfigMap for the AWS IAM Authenticator for Kubernetes. |
| eks_iam_role_arn | The ARN of the IAM role used by the EKS cluster. |

## Future Improvements

- Keep the Terraform code DRY with Terragrunt.
- Use external git repository for the Terraform modules.
- Create IaC tests with native Terraform test framework or Terratest.
- Configure [RBAC](https://docs.aws.amazon.com/eks/latest/userguide/security_iam_troubleshoot.html#security-iam-troubleshoot-cannot-view-nodes-or-workloads) for the EKS cluster. 
- Configure [Fargate](https://docs.aws.amazon.com/eks/latest/userguide/fargate.html) for the EKS cluster.
- Configure [AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html) for the EKS cluster.
- Deploy and expose a sample application to the EKS cluster using Terraform's official [Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs).

## Suggestions

If you wish to further explore the AWS Well-Architected Framework, you can try the following:

- Deploy a monitoring solution to the EKS cluster using Prometheus and Grafana.
- Use Istio to manage the service mesh.
- Alternatively, deploy a custom CNI plugin to the EKS cluster that already includes service mesh, such as Cilium.
- Use FluxCD to deploy and manage the Kubernetes applications.
- Use Flagger to automate the canary deployments.
- Configure [Managed Node Groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html) for the EKS cluster.
- Configure [EKS Anywhere](https://aws.amazon.com/eks/eks-anywhere/) for the EKS cluster.
- Configure [EKS Distro](https://aws.amazon.com/eks/eks-distro/) for the EKS cluster.
- 
## Reference

- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)