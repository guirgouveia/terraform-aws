## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.6.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.23.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.23.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/5.23.1/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.main](https://registry.terraform.io/providers/hashicorp/aws/5.23.1/docs/resources/eks_node_group) | resource |
| [aws_iam_policy.main](https://registry.terraform.io/providers/hashicorp/aws/5.23.1/docs/resources/iam_policy) | resource |
| [aws_iam_policy.main_worker_nodes](https://registry.terraform.io/providers/hashicorp/aws/5.23.1/docs/resources/iam_policy) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/5.23.1/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/5.23.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.main_worker_nodes](https://registry.terraform.io/providers/hashicorp/aws/5.23.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.main](https://registry.terraform.io/providers/hashicorp/aws/5.23.1/docs/resources/key_pair) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/5.23.1/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster. | `string` | `"example-eks-cluster"` | no |
| <a name="input_node_group_desired_capacity"></a> [node\_group\_desired\_capacity](#input\_node\_group\_desired\_capacity) | The desired capacity for the EKS node group. | `number` | `2` | no |
| <a name="input_node_group_instance_size"></a> [node\_group\_instance\_size](#input\_node\_group\_instance\_size) | The instance size to use for the EKS node group | `string` | `"t2.medium"` | no |
| <a name="input_node_group_instance_type"></a> [node\_group\_instance\_type](#input\_node\_group\_instance\_type) | The instance type for the EKS node group instances. | `string` | `"t3.medium"` | no |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | The name of the EKS node group. | `string` | `"example-node-group"` | no |
| <a name="input_scaling_config"></a> [scaling\_config](#input\_scaling\_config) | n/a | <pre>object({<br>    desired_size = number<br>    max_size     = number<br>    min_size     = number<br>  })</pre> | <pre>{<br>  "desired_size": 2,<br>  "max_size": 3,<br>  "min_size": 1<br>}</pre> | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The IDs of the subnets where the EKS cluster will be created. | `list(string)` | <pre>[<br>  "example-subnet-id-1",<br>  "example-subnet-id-2"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to the EKS cluster resources. | `map(string)` | <pre>{<br>  "Environment": "example",<br>  "Owner": "example"<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC where the EKS cluster will be created. | `string` | `"example-vpc-id"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig-certificate-authority-data"></a> [kubeconfig-certificate-authority-data](#output\_kubeconfig-certificate-authority-data) | The certificate authority data for the EKS cluster. |
