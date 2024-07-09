# SimpleAPI EKS Deployment

This project demonstrates how to deploy a simple API to Amazon EKS (Elastic Kubernetes Service) using Terraform for infrastructure provisioning and GitHub Actions for CI/CD.

## Project Structure

project/
├── app/
│ ├── app.py
│ ├── wsgi.py
│ ├── gunicorn.conf.py
│ └── requirements.txt
├── k8s/
│ ├── deployment.yaml
│ ├── service.yaml
│ └── ingress.yaml
├── terraform/
│ ├── main.tf
│ ├── vpc.tf
│ ├── eks.tf
│ ├── iam.tf
│ ├── lb-controller.tf
│ ├── outputs.tf
│ ├── variables.tf
│ └── versions.tf
├── .github/
│ └── workflows/
│ ├── docker-build-push.yml
│ ├── terraform-deploy.yml  
│ └── cleanup.yml
├── Dockerfile
└── README.md

## Components

1. **SimpleAPI**: A Flask-based API application.
2. **Kubernetes Manifests**: YAML files for deploying the API to Kubernetes.
3. **Terraform**: Infrastructure as Code for provisioning EKS and related AWS resources.
4. **GitHub Actions**: CI/CD workflows for deploying and cleaning up resources.

## Setup

### Prerequisites

- AWS Account
- GitHub Account
- Terraform installed locally (for testing)
- AWS CLI configured with appropriate permissions
- kubectl installed locally (for interacting with the cluster)

### AWS Setup

## Recommeded Approach is to setup OIDC for Github

1. Create an OIDC provider for GitHub Actions in your AWS account.
2. Create an IAM role with necessary permissions and trust relationship for GitHub Actions.
3. The IAM role is used for role assumption in two places
   3.1 In the Github Actions as

```
 - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v3
        with:
          role-to-assume: <arn for the role used>
          role-session-name: githubworkflowsession
          aws-region: us-east-1
```

3.2 In the terraform as

```
variable "github_assume_role" {
  description = "IAM Role for Github to use"
  type        = string
  default     = "arn for the role"
}
```

## Deployment

The project uses GitHub Actions for automated deployment:

1. **Terraform Deploy**: Triggered on pushes to the `main` branch that modify files in the `terraform/` directory. It provisions/updates the AWS infrastructure.

2. **Docker Build Push**: Triggered on pushes to the `main` branch. This creates a docker container and pushes it to ECR.

3. **Cleanup**: Can be manually triggered to destroy all created resources.

### Manual Deployment Steps

If you want to deploy manually:

1. Initialize Terraform:

```
cd terraform
terraform init
```

2. Plan and apply Terraform changes:

```
terraform plan
terraform apply
```

# Architecture

The flask API exposes `/chat` and `/healtcheck` endpoints on port `9000`.
The app uses Gunicorn to setup a simple webserver with configuration for log routing and tuning.

**Deployment Manifest**
The EKS Deployment is configured as

1. Set up 1 replica
2. Use the image from ECR
3. Configure resource limits
4. Setup a readiness probe

**Service Configuration**

1. A `ClusterIP service` exposes port 80 from the EKS cluster and forwards to container port 9000
2. An `IngressController` is attached to the EKS Cluster to setup an internet facing load balancer and route traffic to the service.

**Platform**

1. VPC is created with private and public subnets.
2. NAT gateway is created in the VPC to communicate between the public and private subnets.
3. EKS Cluster is created in 2 availability zones.
4. An IAM role is created to attach to the ALB
5. A ALB is created for the cluster
6. All resources are tagged to track resource creation and ownership

**Issues**

1. There is a single NAT Gateway for both AZ's
2. Intentionally chose to not use TLS termination since I did not want to setup my own domain for verification with ACM,

## Application

The SimpleAPI is a basic Flask application with the following endpoints:

- `/chat`: Returns a greeting message
- `/healthcheck`: Health check endpoint

## Cleanup

To destroy all created resources:

1. Trigger the cleanup GitHub Action, or
2. Run `terraform destroy` in the `terraform/` directory

## License

This project is licensed under the MIT License.
