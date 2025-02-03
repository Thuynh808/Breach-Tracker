![CVEDataLake]() 

## Project Overview



## Components



## Use Case



## Versions

| Component         | Version  | Component         | Version  |
|-------------------|----------|-------------------|----------|
| Rocky Linux       | 9.4      | Python            | 3.9.21   |
| AWS CLI           | Latest   | Pip               | 24.3.1   |
| Ansible           | 2.15     | Botocore          | 1.31.0   |
| Community.general | 9.0      | Boto3             | 1.28.0   |
| Amazon.aws        | 9.0      | Requests          | 2.28.2   | 

 

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

**Update variables with proper values for files: `vars.yaml` and `myvars.tfvars`:**
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

## Deployment

**Run Terraform to build our cloud infrastructure:**
```bash
cd terraform
terraform init
terraform apply -var-file=myvars.tfvars -auto-approve
terraform output -json > ../tf_outputs.json
cd ..
ansible-playbook s3.yaml -vv
```
  These commands will:


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

## Athena Queries

The `athena_queries.yaml` file contains sample queries designed to extract valuable insights from the CVE data lake. Each query focuses on a specific aspect of vulnerability management, such as critical vulnerabilities, vendor trends, or severity distributions.


**Extending Queries**
- This file can be easily updated with new queries to meet evolving requirements. Simply modify `athena_queries.yaml`, then run the playbook to generate updated JSON report files, enabling continuous adaptability and insights.

**Now let's run the Sample Query Reports Playbook:**
```bash
ansible-playbook sample-reports.yaml -vv
```
  The `sample-reports.yaml` playbook will:
  - Define `Athena` queries to extract insights from the CVE data stored in the data lake
  - Execute the queries in `Athena` and capture the corresponding execution IDs
  - Download the resulting CSV files from the `S3` bucket using the captured execution IDs
  - Process, format the CSV files into JSON, and output to `query_results` directory using a Python script for improved readability and usability

> Note: *This playbook automates the process of running predefined queries, fetching their results, and preparing them in JSON format for use in dashboards, reports, or further analysis.*

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

## Conclusion

CVEDataLake combines the power of AWS tools like S3, Glue, and Athena with Ansible automation to make vulnerability management seamless and efficient! Its modular design means you can easily add new queries, scale for larger datasets, or tweak it to meet specific needs. This makes it an incredible tool for SOC teams, security analysts, and even generating custom reports for audits, dashboards, or compliance.
