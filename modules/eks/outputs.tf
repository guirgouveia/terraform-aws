output "kubeconfig-certificate-authority-data" {
  value       = aws_eks_cluster.main.certificate_authority[0].data
  description = "The certificate authority data for the EKS cluster."
}

output "kubeconfig" {
  description = "The kubectl configuration for the EKS cluster."
  value       = local.kubeconfig
}