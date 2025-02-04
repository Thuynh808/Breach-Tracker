![breach-tracker]() 

## Project Overview

Breach Tracker is an AWS-based architecture designed to automate the retrieval and serving of breach data from **"Have I Been Pwned"**. The project leverages ECS (Fargate), API Gateway, ALB, ECR, Terraform, and Ansible to deploy a scalable and secure backend for breach tracking.

## Architecture:

- **Rocky Linux**: Used as a development environment for building, testing, and deploying infrastructure and application components
- **Ansible**: Automate environment setup with packages and dependencies along with `ECR` repository creation with image
- **Terraform**: Modules to automate and manage infrastructure as code with reusable configurations
- **Python Flask App**:
  - Fetches breach data from the **Have I Been Pwned** API
  - Sorts breaches by date to show the latest first
  - Serves the data as JSON for analysis
- **VPC & Networking**:
  - Configured with `public` and `private` subnets across two availability zones for high availability and enhanced security
  - `ECS` tasks and `ALB` are placed in `private` subnets to restrict public access
- **NAT Gateway**: Deployed in `public` subnets; enables ECS tasks in `private` subnets to securely fetch breach data from external sources
- **ECS & ECR**: Flask application containerized and deployed on `ECS Fargate` for fetching breach data, with images stored in `ECR`
- **ALB**: `Internal` Application Load Balancer routes traffic securely to `ECS` tasks within `private` subnets
- **API Gateway**: Public API interface integrated with ALB via VPC Link for secure communication between `public` and `private` subnets
- **VPC Link**:
  - Bridges the `API Gateway` with the internal `ALB` to secure traffic routing from the public API to private resources
  - Restricted `security group` to only allow inbound traffic from AWS's public API Gateway endpoints CIDR ranges 
- **Security & IAM**: Configured `security groups` for traffic control and `IAM` roles to ensure appropriate permissions for ECS, ALB, and API Gateway interactions

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
  - Install `pip` modules with required versions
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
pip list | egrep "boto3|botocore|requests" 
aws configure list
aws sts get-caller-identity
aws ecr list-images --repository-name breach-tracker --region us-east-1
```

<details close>
  <summary> <h3>Image Results</h3> </summary>
    
![breach-tracker]()
![breach-tracker]() 
![breach-tracker]() 
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
    
![breach-tracker]()
![breach-tracker]() 
![breach-tracker]() 

</details>
<details close>
  <summary> <h3>Extended Bonus Feature</h3> </summary>
  
**Run Ansible playbook to setup `s3` bucket and host a static website to populate a simple table with our breach data:**
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
    
![breach-tracker]()
![breach-tracker]() 
![breach-tracker]() 

  - **List S3**: Bucket contains results under athena-results/, including .csv and .csv.metadata files
  - **List local directory**: Confirmed `~/CVEDataLake/query_results/` has multiple JSON query result files
  - **Examine JSON file**: Results confirm properly formatted structured JSON data
</details>

---
<br>

## Conclusion

Building Breach Tracker was a solid hands-on experience into AWS infrastructure, automation, and debugging real-world deployment issues. I ran into countless networking misconfigurations, IAM headaches, and API Gateway problems. Solving them gave me a stronger understanding of ECS, ALB, API Gateway, Terraform, and Ansible. 

The greatest highlight is integrating **private and public services** which required careful routing, security group tuning, and IAM permissions to balance security and functionality. 

Now, I have a fully automated system that fetches and serves breach data while reinforcing best practices in networking, security, and infrastructure-as-code. There’s always room for improvement, but for now, I’m happy with how everything came together. 🚀
