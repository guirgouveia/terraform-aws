# Define the output variables for the module
output "kubeconfig" {
  description = "The kubectl configuration for the EKS cluster."
  value       = module.eks.kubeconfig-certificate-authority-data
}