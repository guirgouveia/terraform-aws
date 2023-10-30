locals {
  kubeconfig = <<-KUBECONFIG

    ---
    apiVersion: v1
    clusters:
    - cluster:
        server: ${aws_eks_cluster.main.endpoint}
        certificate-authority-data: ${aws_eks_cluster.main.certificate_authority.0.data}
      name: eks-test
    contexts:
    - context:
        cluster: eks-test
        user: aws
      name: eks-test
    current-context: eks-test
    kind: Config
    preferences: {}
    users:
    - name: aws
      user:
        exec:
          apiVersion: client.authentication.k8s.io/v1alpha1
          command: aws-iam-authenticator
          args:
            - "token"
            - "-i"
            - "${aws_eks_cluster.main.name}"
  KUBECONFIG
}