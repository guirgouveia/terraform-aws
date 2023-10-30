# VPC Module

This module creates all the network related resources in AWS, such as VPC, subnets, NAT Gateway, Internet Gateway, NACLs, and Route Tables.

## Multiple Availability Zones

[Amazon EKS recommends](https://aws.github.io/aws-eks-best-practices/networking/index/#amazon-virtual-private-cloud-vpc-cni) you specify subnets in at least two availability zones when you create a cluster. Amazon VPC CNI allocates IP addresses to Pods from the node subnets. We strongly recommend checking the subnets for available IP addresses. Please consider [VPC and Subnet](/Users/grgouveia/studies/devops/iac/terraform/terraform-modules/aws/vpc/README.md) recommendations before deploying EKS clusters.

## Benefits of Creating a New VPC for EKS:

* Isolation: A dedicated VPC provides a clear boundary for your Kubernetes environment. This can simplify security management, monitoring, and auditing. You can tailor security groups, Network ACLs, and routing specifically for EKS without affecting other services.
* Simplified Networking: Setting up EKS requires certain networking configurations, like VPC tagging and specific CIDR block sizes based on expected nodes/pods. A dedicated VPC allows you to design the network with EKS in mind from the start.
* Flexibility: As your Kubernetes workloads grow or change, having a dedicated VPC means you can make network adjustments without risking disruptions to other services.
* Performance: A dedicated VPC ensures that the network performance of EKS is not impacted by other services. You can optimize the VPC settings solely for EKS traffic patterns.

If you're setting up EKS for a production environment or expect it to grow significantly, creating a new VPC specifically for EKS is often the better choice. This approach aligns with the best practices of isolation and security, especially considering the AWS Well-Architected Framework.

However, **if you're creating a smaller EKS cluster for development**, testing, or if it needs to be closely integrated with existing services, using an existing VPC might be more practical.

# Subnets

We are following the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) to ensure that our infrastructure is secure, reliable, efficient, and cost-effective.

In this AWS setup, we utilize both an Internet Gateway (IGW) and a NAT Gateway (NAT GW) to manage traffic. The IGW facilitates direct communication between instances in the public subnet and the internet. On the other hand, the NAT GW, residing in the public subnet, allows instances in the private subnet to access the internet securely, without being directly accessible.

The routing configuration entails two separate route tables. The public subnet's route table contains a route directing internet-bound traffic to the IGW, enabling direct internet access. Meanwhile, the private subnet's route table has a route pointing to the NAT GW for internet-bound traffic, ensuring secure, indirect internet access for private instances.

So, to summarize:

- The public subnet's route table has a route to the IGW for internet-bound traffic.
- The NAT Gateway resides in the public subnet, utilizing the IGW for internet access.
- The private subnet's route table has a route to the NAT Gateway for internet-bound traffic.

## NAT Gateway and Internet Gateway Instances

In this configuration, each Availability Zone (AZ) has its own NAT Gateway to ensure high availability, minimize cross-AZ data charges, and reduce latency. If one AZ experiences an outage, the others remain unaffected in terms of internet access via their respective NAT Gateways.

Hence, we have two Elastic IPs (EIPs), one for each NAT Gateway, to ensure that the IP addresses remain static even if the NAT Gateways are replaced. The EIPs are attached to the NAT Gateways, which are in turn attached to the public subnets.

Each private subnet's route table contains a route (`0.0.0.0/0`) directing internet-bound traffic to the NAT Gateway in the same AZ, ensuring optimal routing and minimizing the chances of a single point of failure affecting multiple AZs.

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