Terraform is an Infrastructure as Code (IaC) tool by HashiCorp that allows you to define, provision, and manage infrastructure across cloud providers using declarative configuration files.

### Why Terraform

- Ideal for creating and managing infrastructure.
- Uses **HCL (HashiCorp Configuration Language)** — a human-readable, declarative language.

### Example

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0abcd1234"
  instance_type = "t2.micro"
}
```

### How Terraform Communicates with Cloud Providers

1. **Providers (Plugins)**
   Terraform uses provider plugins to communicate with clouds.

   - `hashicorp/aws` for AWS
   - `hashicorp/azurerm` for Azure
   - `hashicorp/google` for GCP

2. **APIs**
   Each provider calls the official cloud API (REST or SDK) to create resources.

3. **Authentication**
   Terraform needs credentials to access APIs:

   ```hcl
   provider "aws" {
     access_key = "YOUR_ACCESS_KEY"
     secret_key = "YOUR_SECRET_KEY"
     region     = "us-east-1"
   }
   ```

4. **Terraform Workflow**

   - `init` → Download providers
   - `plan` → Preview changes
   - `apply` → Create or modify resources
   - `state` → Save results locally or remotely

### Example Flow

```hcl
resource "aws_s3_bucket" "demo" {
  bucket = "my-demo-bucket"
}
```

Terraform uses the AWS provider to authenticate, send an API call, and record the result in `terraform.tfstate`.

**Summary:**
Terraform communicates through provider plugins that use official cloud APIs to create and manage resources.

---

## AWS CLI Installation & Configuration

### 1. Install AWS CLI

**macOS**

```bash
brew install awscli
aws --version
```

**Windows**

```bash
choco install awscli
aws --version
```

Manual installers are available at:
[https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

---

### 2. Configure AWS CLI

```bash
aws configure
```

Enter:

```
AWS Access Key ID [None]: test
AWS Secret Access Key [None]: test
Default region name [None]: us-east-1
Default output format [None]: json
```

Configuration files:

```
~/.aws/credentials
~/.aws/config
```

**Windows path:**

```
C:\Users\<username>\.aws\
```

---

### 3. Test Configuration

```bash
aws s3 ls
```

**With LocalStack:**

```bash
aws --endpoint-url=http://localhost:4566 s3 ls
```

---

### 4. Optional: Custom Profiles

```bash
aws configure --profile localstack
aws --profile localstack --endpoint-url=http://localhost:4566 s3 ls
```

---

## LocalStack Setup

LocalStack emulates AWS services locally using Docker — perfect for testing Terraform and AWS CLI without real AWS credentials.

### Why Use LocalStack

- Avoid AWS costs
- Work offline
- Fast and safe testing
- Supports S3, EC2, Lambda, DynamoDB, and more

---

### 1. Prerequisites

| Tool           | Purpose                | macOS Install Command            |
| -------------- | ---------------------- | -------------------------------- |
| Docker Desktop | Runs containers        | `brew install --cask docker`     |
| Python 3.8+    | Required for CLI       | Preinstalled                     |
| pip            | Python package manager | `python3 -m ensurepip --upgrade` |

---

### 2. Install LocalStack

```bash
pip install localstack awscli-local
localstack --version
```

---

### 3. Start LocalStack

```bash
localstack start
```

Runs on `http://localhost:4566`.

---

### 4. Web Dashboard

![alt text](<Screenshot 2025-10-05 at 8.22.20 PM.png>)
![alt text](<Screenshot 2025-10-05 at 8.23.33 PM.png>)

---

### 5. Test

```bash
awslocal s3 ls
awslocal s3 mb s3://demo-bucket
```

---

### 6. Docker Compose Example

```yaml
version: "3.8"
services:
  localstack:
    image: localstack/localstack
    ports:
      - "4566:4566"
    environment:
      - SERVICES=s3,ec2,lambda
      - DEBUG=1
    volumes:
      - "./localstack:/var/lib/localstack"
```

Run:

```bash
docker-compose up
```

---

## Terraform + LocalStack Integration

### Project Structure

```
terraform-localstack-demo/
├── main.tf
├── provider.tf
├── outputs.tf
└── hello.txt
```

### Step 1: Create a Test File

```bash
echo "Hello from Terraform + LocalStack!" > hello.txt
```

---

### Step 2: provider.tf

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    s3 = "http://localhost:4566"
  }
}
```

---

### Step 3: main.tf

```hcl
resource "aws_s3_bucket" "demo" {
  bucket = "terraform-localstack-demo"
}

resource "aws_s3_object" "file_upload" {
  bucket = aws_s3_bucket.demo.id
  key    = "hello.txt"
  source = "hello.txt"
  etag   = filemd5("hello.txt")
}
```

---

### Step 4: outputs.tf

```hcl
output "bucket_name" {
  value = aws_s3_bucket.demo.bucket
}
```

---

### Step 5: Deploy

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

Verify:

```bash
awslocal s3 ls
awslocal s3 ls s3://terraform-localstack-demo/
```

---

## Cleanup and Destroy

### Destroy Resources

```bash
terraform destroy -auto-approve
```

Output:

```
Destroy complete! Resources: 2 destroyed.
```

---

### Optional: Preview Destroy

```bash
terraform plan -destroy
```

---

### Verify Deletion

```bash
awslocal s3 ls
```

---

### Reset LocalStack (Optional)

```bash
localstack stop
docker rm -f localstack
docker volume prune -f
localstack start
```
