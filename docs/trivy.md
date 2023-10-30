# Trivy

[Trivy](https://trivy.dev) is a simple and comprehensive vulnerability scanner for containers and other artifacts, suitable for DevSecOps environments. It can be used to scan for vulnerabilities and secrets in your Terraform code, as well as in your plan files and remote repositories.

## Running Trivy

After [installing Trivy](https://aquasecurity.github.io/trivy/v0.46/getting-started/installation/) in your local machine, you can perform a static code analysis for secrets, vulnerabilities and misconfigurations with the [trivy fs](https://aquasecurity.github.io/trivy/v0.46/docs/target/filesystem/) command.

Vulnerabilities and secrets scanning are enabled by default, but you need to explicitly indicate if you wish to scan for misconfigurations and licenses too. 

For example:

```bash
trivy fs --scanners secret,config,vuln,lincense \ # Enables all scanners
  -o trivy-scan.json         \                    # Defines the output file
  --severity HIGH, CRITICAL   \                   # Filter by severity
  --tf-vars terraform.tfvars \                    # Override variables
  ./modules/eks \
```

You can run the commnad for specific files or directories or even the whole project. Read the manual for the complete list of options.

### Scanning the plan file

It's also a good practice to run Trivy on your plan file, so you can check for vulnerabilities and misconfigurations as they would be. To do so, run the following commands:

```bash
terraform plan --out tfplan.binary
terraform show -json tfplan.binary > tfplan.json # Converts the binary plan file to JSON
trivy config ./tfplan.json -o trivy-plan-scan.json   # Scans the plan file
```

### Scannig repositories

It's also always good to verify if there's a secret vulnerability in the remote repository by running:

```
trivy repo \
--scanners secret \
https://github.com/guirgouveia/terraform-aws
```

## VS Code Plugin

Installing the [Trivy VS Code Plugin](https://marketplace.visualstudio.com/items?itemName=AquaSecurityOfficial.trivy-vulnerability-scanner) to scan your Terraform code directly from VS Code can be very handy.

## CICD

Run Trivy in your CI pipeline to ensure that your code is secure and free of vulnerabilities and misconfigurations. You can use the [Trivy GitHub Action](https://github.com/marketplace/actions/trivy-action) to do so, or just run the commands above and make sure to fail the pipeline if any vulnerabilities or misconfigurations are found, adding the following flag:

```
trivy fs --scanners secret, config \
  ...
  --exit-code 0
```

[This blog post](https://blog.aquasec.com/devsecops-with-trivy-github-actions) from Aquasec explains how to use Trivy in your GitHub Actions pipeline.

## Trivy Tutorials

Refer to the [Trivy tutorials](https://aquasecurity.github.io/trivy/v0.46/tutorials/misconfiguration/terraform/) about Terraform scanning for more information. 
