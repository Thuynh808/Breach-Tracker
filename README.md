# BREACH TRACKER
![breach-tracker](https://i.imgur.com/tcFhk5o.png)

## Project Overview

Breach Tracker is an AWS-based architecture that automates retrieving and serving breach data from "Have I Been Pwned". A custom Flask app fetches, processes, and sorts breach data by date added, then is containerized with Podman/Docker and deployed on ECS Fargate via ECR.

The project uses Terraform for infrastructure provisioning and Ansible for automating setup and development environment. With multi-AZ, API Gateway, an Internal ALB, and NAT Gateways, it delivers a secure and scalable backend following best practices for breach tracking.

## Architecture:

- **Rocky Linux**:
  - Used as a development environment for building, testing, and deploying infrastructure and application components
- **Ansible**:
  - Automate environment setup with packages/dependencies and `ECR` repository creation with image
- **Terraform**:
  - Modules to automate and manage infrastructure as code with reusable configurations
- **Python Flask App**:
  - Fetches breach data from the **Have I Been Pwned** API
  - Sorts breaches by date to show the latest first
  - Serves the data as JSON for analysis
- **VPC & Networking**:
  - Configured with `public` and `private` subnets across two availability zones for high availability and enhanced security
  - `ECS` tasks and `ALB` are placed in `private` subnets to restrict public access
- **NAT Gateway**:
  - Deployed in `public` subnets; enables ECS tasks in `private` subnets to securely fetch breach data from external sources
- **ECS & ECR**:
  - Flask application containerized and deployed on `ECS Fargate` to fetch breach data; images stored in `ECR`
- **ALB**:
  - `Internal` Application Load Balancer routes traffic securely to `ECS` tasks within `private` subnets
- **API Gateway**:
  - Public API interface integrated with ALB via VPC Link for secure communication between `public` and `private` subnets
- **VPC Link**:
  - Bridges the `API Gateway` with the internal `ALB` to secure traffic routing from the public API to private resources
  - Restricted `security group` to only allow inbound traffic from AWS's public API Gateway endpoints CIDR ranges 
- **Security & IAM**:
  - Configured `security groups` for traffic control and `IAM` roles to ensure appropriate permissions for ECS, ALB, and API Gateway interactions

## Versions

| Component         | Version  | Component         | Version  |
|-------------------|----------|-------------------|----------|
| Rocky Linux       | 9.4      | Python            | 3.9.21   |
| AWS CLI           | Latest   | Pip               | 24.3.1   |
| Ansible           | 2.15     | Botocore          | 1.31.0   |
| Community.general | 9.0      | Boto3             | 1.28.0   |
| Amazon.aws        | 9.0      | Requests          | 2.28.2   | 
| Terraform         | 1.10.5   | Podman-Docker     | 5.2.2    | 
 
## Prerequisites

- **Rocky Linux VM**
  - Fresh installation of Rocky Linux
  - Allocate sufficient resources: **2 CPUs, 4GB RAM**
- **AWS Account**
   - An AWS account with provisioned access-key and secret-key

## Initial Setup

**Run the following to setup our VM:**
```bash
cd
dnf install -y git ansible-core
git clone -b feature https://github.com/Thuynh808/Breach-Tracker
cd Breach-Tracker
ansible-galaxy collection install -r requirements.yaml -vv
```
  Command Breakdown:
  - Navigates to home directory
  - Installs `Git` and `Ansible`
  - Clone repository
  - Navigates to project directory
  - Install required Ansible Collections

### Define Variables

**Update variables with necessary values for files: `vars.yaml` and `myvars.tfvars`:**
```bash
vim vars.yaml
```
```bash
---
aws_account_id: "<your-account-id>"
aws_access_key_id: "<your-access-key-id>"
aws_secret_access_key: "<your-secret-access-key>"
defaultregion: "us-east-1"
project_name: "breach-tracker"
```
```bash
vim terraform/myvars.tfvars
```
```bash
project_name        = "breach-tracker"
aws_region          = "us-east-1"
vpc_cidr            = "10.2.0.0/16"
public_subnet_cidr  = ["10.2.22.0/24", "10.2.24.0/24"] 
private_subnet_cidr = ["10.2.23.0/24", "10.2.25.0/24"]
availability_zones  = ["us-east-1a", "us-east-1b"]
```
**Set permissions to secure file**
```bash
chmod 0600 vars.yaml 
```
> Note: Keep the sensitive file local. Add to `.gitignore` if uploading to GitHub
<br>

## Environment Setup

**Run `setup_infra.yaml` playbook:**
```bash
ansible-playbook setup_infra.yaml -vv
```
  The `setup_infra.yaml` playbook will:
  - Install and upgrade required packages
  - Install `pip` libraries with required versions
  - Download, unzip and install `AWS CLI`
  - Configure `AWS CLI` with credentials
  - Build the `Flask` app and upload to `ECR`

**Confirm Successful Execution:**
```bash
ansible --version
terraform --version
podman --version
python3 --version
pip --version
pip list | egrep -i "Flask|boto3|botocore|requests" 
aws configure list
aws sts get-caller-identity
aws ecr list-images --repository-name breach-tracker --region us-east-1
```

<details close>
  <summary> <h3>Image Results</h3> </summary>
    
![breach-tracker](https://i.imgur.com/E7iWTvv.png)

- **Dependencies**:
  - Python 3.9.21 and pip are installed along with required libraries:
    - boto3
    - botocore
    - Flask
    - requests 
  - Ansible 2.15.13  installed, configured, and ready for use
  - Terraform 1.10.5 installed and functional
  - Podman 5.2.2 installed for container management
- **AWS CLI Configuration**:
  - AWS credentials are set up using a shared credentials file, and the region is configured as us-east-1
  - The IAM user is verified via sts get-caller-identity, confirming its UserId, Account, and ARN
- **ECR Repository Status**:
  - Amazon Elastic Container Registry (ECR) repository named `breach-tracker` exists, and tagged as `breach-tracker-latest`
</details>

---
<br>

## Deployment

**Run Terraform to build our cloud infrastructure:**
```bash
cd terraform
terraform init
terraform apply -var-file=myvars.tfvars -auto-approve
terraform output -json > ../tf_outputs.json
```
  The above commands will:
  - Initialize the working directory for `Terraform` by downloading providers and initializing the backend
  - Provisions and modifies infrastructure based on our configurations:
    - VPC Module: Creates public and private subnets, NAT Gateway, and networking resources
    - IAM Module: Defines roles, policies, and permissions for secure service access
    - ECS Module: Provisions Fargate tasks and services for the breach-tracking app
    - ALB Module: Sets up an internal load balancer for secure traffic distribution
    - API Gateway Module: Configures an HTTP API with a VPC Link for private ALB integration
  - Output `json` file with result variables from our Terraform run
    
<details close>
  <summary> <h3>Image Results</h3> </summary>
    
![breach-tracker](https://i.imgur.com/0ou3I6g.png)

- **Module Initialization**:
  - Modules for alb, api_gateway, ecs, iam, and vpc have been loaded from their respective directories
- **Provider Setup**:
  - The hashicorp/aws provider (v5.85.0) installed and locked for consistent infrastructure provisioning
- **Successful Initialization**:
  - Terraform ready for use
<br><br>

![breach-tracker](https://i.imgur.com/dpPJ0kV.png) 

- **Resource Deployment**:
  - Total of 76 resources were created, with no changes or deletions
- **Successful Execution**:
  - Terraform confirmed the completion of all resources, ensuring the infrastructure is ready to support the `Breach Tracker` application.
<br><br>

![breach-tracker](https://i.imgur.com/1D1kwN0.png) 

Result outputs from our Terraform run:
- **Application Endpoint**:
  - The API Gateway endpoint is displayed as: `https://vlbbbfr738b.execute-api.us-east-1.amazonaws.com/breaches`
  - This URL can be used to interact with the Breach Tracker API
- **Application Load Balancer (ALB)**:
  - Details of the ALB include its ARN, DNS name, listener ARN, and target group ARN, indicating a fully configured internal load balancer
- **ECS Configuration**:
  - Cluster name: breach-tracker-cluster
  - Service name: breach-tracker-service
  - ECS security group id
  - Task definition ARN and execution role ARN are also listed
- **Networking**:
  - Internet Gateway ID
  - NAT Gateway IDs
  - Public and private route table IDs
  - Subnet IDs for public and private subnets
  - VPC ID and VPC Link security group ID
<br><br>

![breach-tracker](https://i.imgur.com/DTeEr3z.png) 
<br><br>
### LET'S GO!! Our API Endpoint is accessible and returning data!
Fields include AddedDate, BreachDate, DataClasses, Domain, Description, and more, ensuring data is structured for further formatting
<br><br>
</details>

<details close>
  <summary> <h3>Extended Bonus Feature</h3> </summary>
  
**Let's run the following Ansible playbook to setup an `s3` bucket and host a static website to populate a simple table with our breach data:**
```bash
cd ../
ansible-playbook s3.yaml -vv
```
  The `s3.yaml` playbook will:
  - Set variables from our *`tf_outputs.json`* for `Ansible` 
  - Create `s3` bucket with `IAM` policy
  - Upload sample `index.html` to display our data
  - Setup our static website
  - Configure `CORS` settings for `s3` and `API Gateway`
    
![breach-tracker](https://i.imgur.com/MRcDW0T.png)
![breach-tracker](https://i.imgur.com/LzyyOOT.png) 

**The Breach Tracker Static Website displays breach data in a table format with Name, Domain, Added Date, and Data Classes.**

This sample demonstrates how data from the API Gateway and Breach Tracker app can be utilized.

</details>

---
<br>

## Conclusion

Building Breach Tracker was a valuable hands-on experience with AWS infrastructure, automation, and debugging deployment issues. Using `depends_on` in Terraform ensured resources were created in the correct order, avoiding errors. A key highlight was integrating `private` and `public` services, requiring careful routing, security group tuning, and IAM adjustments.

The system now fetches and serves breach data while following best practices in networking, security, and infrastructure-as-code. Future improvements could include HTTPS with TLS/SSL certificates and a Web Application Firewall (WAF), but for now, I’m happy with how everything came together. 🚀

> Note: Run `cleanup.sh` to delete all resources
