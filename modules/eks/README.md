# EKS Module

This module provisions an EKS cluster on AWS.

## Usage

```hcl
module "eks" {
    source = "github.com/your-username/eks"

    cluster_name = "my-eks-cluster"
    region       = "us-west-2"
    vpc_id       = "vpc-1234567890"
    subnets      = ["subnet-1234567890", "subnet-0987654321"]
}
```

## Inputs and Outputs

Read the auto-generated [documentation](./terraform-docs.md) for more information about the inputs and outputs description and usage.

# References

* [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)

## Security Groups and NACLs

Network Access Control Lists (NACLs) and Security Groups serve as mechanisms to control inbound and outbound traffic to network interfaces, subnets, and VPCs. However, they operate at different levels and have different behaviors. While Security Groups operate at the instance level, NACLs operate at the subnet level.
Although not necessary, as a best practice, you should use both Security Groups and NACLs to provide multiple layers of security for your VPCs and subnets.

In our AWS setup, we use [Security Groups](./security-groups.tf) to control the traffic to the EKS cluster and [NACLs](./nacls.tf) to control the traffic to the subnets where the EKS cluster is deployed.

## IAM Roles

The [IAM Roles](./iam-roles.tf) created by this module are used by the EKS cluster to access other AWS services, such as EC2, ELB, and Auto Scaling.