<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [VPC Module](#vpc-module)
  - [Multiple Availability Zones](#multiple-availability-zones)
  - [Advantages of Creating a New VPC for EKS:](#advantages-of-creating-a-new-vpc-for-eks)
  - [Usage](#usage)
  - [Inputs and Outputs](#inputs-and-outputs)
  - [Test Cases](#test-cases)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# VPC Module

This module creates a VPC in AWS.

## Multiple Availability Zones

[Amazon EKS recommends](https://aws.github.io/aws-eks-best-practices/networking/index/#amazon-virtual-private-cloud-vpc-cni) you specify subnets in at least two availability zones when you create a cluster. Amazon VPC CNI allocates IP addresses to Pods from the node subnets. We strongly recommend checking the subnets for available IP addresses. Please consider [VPC and Subnet](/Users/grgouveia/studies/devops/iac/terraform/terraform-modules/aws/vpc/README.md) recommendations before deploying EKS clusters.

## Advantages of Creating a New VPC for EKS:

* Isolation: A dedicated VPC provides a clear boundary for your Kubernetes environment. This can simplify security management, monitoring, and auditing. You can tailor security groups, Network ACLs, and routing specifically for EKS without affecting other services.
* Simplified Networking: Setting up EKS requires certain networking configurations, like VPC tagging and specific CIDR block sizes based on expected nodes/pods. A dedicated VPC allows you to design the network with EKS in mind from the start.
* Flexibility: As your Kubernetes workloads grow or change, having a dedicated VPC means you can make network adjustments without risking disruptions to other services.
* Performance: A dedicated VPC ensures that the network performance of EKS is not impacted by other services. You can optimize the VPC settings solely for EKS traffic patterns.

If you're setting up EKS for a production environment or expect it to grow significantly, creating a new VPC specifically for EKS is often the better choice. This approach aligns with the best practices of isolation and security, especially considering the AWS Well-Architected Framework.

**However, if you're creating a smaller EKS cluster for development, testing, or if it needs to be closely integrated with existing services, using an existing VPC might be more practical.**

## Usage

```terraform
module "vpc" {
  source = "path/to/vpc"

  create_vpc               = true
  vpc_name                 = "my-vpc"
  vpc_cidr_block           = "10.0.0.0/16"
  nat_gateway_count        = 1
  availability_zones_count = 1
}

resource "aws_eks_cluster" "example" {

  vpc_config {
    vpc_id     = module.vpc.vpc_id
  }

  # ...

}
```

## Inputs and Outputs

Read the auto-generated [documentation](./terraform-docs.md) for more information about the inputs and outputs.

This documentation was generated automatically using [terraform-docs](https://terraform-docs.io).

## Test Cases

This module has been packaged with the native Terraform testing framework. The test cases are located in the [test](./test) directory.

Tests require version 1.6.0 or higher of Terraform. Run the tests with `terraform test`.