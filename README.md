![CVEDataLake]() 

## Project Overview

Breach Tracker is an AWS-based architecture designed to automate the retrieval and serving of breach data from **"Have I Been Pwned"**. The project leverages ECS (Fargate), API Gateway, ALB, ECR, Terraform, and Ansible to deploy a scalable and secure backend for breach tracking.

## Architecture:

- **VPC & Networking**:
  - Configured with `public` and `private` subnets across two availability zones for high availability and enhanced security
  - `ECS` tasks and `ALB` are placed in `private` subnets to restrict public access
- **NAT Gateway**: Deployed in `public` subnets; enables ECS tasks in `private` subnets to securely fetch breach data from external sources
- **ECS & ECR**: Flask application containerized and deployed on `ECS Fargate` for fetching breach data, with images stored in `ECR`
- **ALB**: `Internal` Application Load Balancer routes traffic securely to `ECS` tasks within `private` subnets
- **API Gateway**: Public API interface integrated with ALB via VPC Link for secure communication between `public` and `private` subnets
- **VPC Link**: Bridges the `API Gateway` with the internal `ALB` to secure traffic routing from the public API to private resources
- **Terraform**: Manages infrastructure as code, automating the provisioning of AWS resources
- **Ansible**: Automate environment setup with packages and dependencies along with `ECR` repository creation 
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

## Environment Setup

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

## Define Variables

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
**Run `setup_infra.yaml` playbook:**
```bash
ansible-playbook setup_infra.yaml -vv
```

## Deployment

**Run Terraform to build our cloud infrastructure:**
```bash
cd terraform
terraform init
terraform apply -var-file=myvars.tfvars -auto-approve
terraform output -json > ../tf_outputs.json
```

<details close>
  <summary> <h4>Image Results</h4> </summary>
    
![CVEDataLake](https://i.imgur.com/TOHj0Kz.png)
![CVEDataLake](https://i.imgur.com/PhcouoU.png)
  
- **Environment Setup**:
---
<br><br>
![CVEDataLake](https://i.imgur.com/wob1hNt.png)

**Glue Table Schema**: 
 - Navigating to the Glue table in the AWS console, we can verify its schema to ensure it aligns with the data structure needed for our queries 
  </details>

---
<br>

**Bonus: Ansible playbook to setup `s3` bucket and host a static website to populate a table with our breach data**

```bash
cd ../
ansible-playbook s3.yaml -vv
```

**Confirm Successful Execution:**

```bash
aws s3 ls s3://cve-data-lake-thuynh/athena-results/ #Change "cve-data-lake-thuynh" to your bucket name
ll ~/CVEDataLake/query_results/
cat ~/CVEDataLake/query_results/Top_100_Critical_Windows_Vulnerabilities.json | head -40
```
<details close>
  <summary> <h4>Image Results</h4> </summary>
    
![CVEDataLake](https://i.imgur.com/idwIvVZ.png)
![CVEDataLake](https://i.imgur.com/fWI7OLO.png)

  - **List S3**: Bucket contains results under athena-results/, including .csv and .csv.metadata files
  - **List local directory**: Confirmed `~/CVEDataLake/query_results/` has multiple JSON query result files
  - **Examine JSON file**: Results confirm properly formatted structured JSON data
  </details>

---
<br>

## Challenges

1. VPC & Subnet Issues
ALB was initially deployed in private subnets, causing connectivity issues.
ECS tasks could not access the internet due to missing NAT Gateway.
Solution:

Moved ALB to public subnets and kept ECS tasks in private subnets.
Added a NAT Gateway for outbound access from ECS tasks.
2. ECS & ECR Challenges
Podman compatibility issues when pushing images to ECR.
ECS Service failed due to missing target group attachment.
Solution:

Used Podman’s ECR login method instead of Docker CLI.
Ensured correct image tagging before pushing (repository:tag).
Added aws_lb_target_group_attachment in Terraform.
3. ALB & API Gateway Integration Issues
API Gateway initially returned 403 Forbidden due to missing IAM permissions.
ALB security group allowed API Gateway CIDR blocks instead of VPC Link CIDR blocks.
Solution:

Updated API Gateway integration URI to ALB Listener ARN.
Added IAM permissions for API Gateway to invoke the integration.
4. API Gateway Issues
API Gateway returned Missing Authentication Token due to incorrect route mappings.
API Gateway returned Not Found (404) due to incorrect /breaches/{proxy+} mapping.
Solution:

Fixed route key (ANY /breaches instead of ANY /breaches/{proxy+}).
Ensured API Gateway was deployed correctly after updates.
5. Security Group & Networking Issues
ECS tasks couldn't access the internet for API calls.
API Gateway security group not allowing traffic to ALB.
Solution:

Routed ECS tasks through a NAT Gateway for outbound access.
Updated API Gateway and ALB security groups accordingly.
6. Terraform & Ansible Automation Issues
Terraform variable issues (private_subnet_id needed to be a list).
Incorrect target group port mapping (hostPort: 80 instead of 8080).
Solution:

Fixed Terraform variables and security group rule conflicts.
Ensured correct port mapping in the target group.

## Lessons Learned
1️⃣ API Gateway and Flask API must have matching route mappings.
2️⃣ ALB must have the correct listener and forwarding rules to ECS tasks.
3️⃣ ECS tasks in private subnets require a NAT Gateway for outbound API calls.
4️⃣ Flask must bind to 0.0.0.0:80 to be reachable within ECS containers.
5️⃣ IAM permissions must be precise but allow necessary AWS interactions.

## Conclusion

Building Breach Tracker was a solid hands-on experience in AWS infrastructure, automation, and debugging real-world deployment issues. I ran into plenty of challenges—networking misconfigurations, IAM permission headaches, API Gateway quirks—but solving them helped me get a deeper understanding of ECS, ALB, API Gateway, Terraform, and Ansible. Now, I have a fully automated system that fetches and serves breach data, and I’ve reinforced best practices for networking, security, and infrastructure-as-code along the way. There’s always room for improvement, but for now, I’m happy with how everything came together. 🚀


