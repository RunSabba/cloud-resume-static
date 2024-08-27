# Cloud Resume Challenge

This project is part of the **Cloud Resume Challenge**. It will help me futher expand my skillset by demonstrating the deployment of a personal resume website using Terraform, GitHub Actions, and various AWS services. The infrastructure is fully automated and follows best practices in cloud development. This project will solidfy my knowledge and give me confidence that i can make it in this field.

## Project Overview

The Cloud Resume Challenge is designed to showcase skills in cloud technologies, including:

- **Infrastructure as Code (IaC)**: Using Terraform to define and deploy infrastructure.
- **CI/CD**: Leveraging GitHub Actions for continuous integration and continuous deployment.
- **AWS Services**: Utilizing various AWS services to build and host the resume.

## Architecture Diagram

![Architecture Diagram](./architecture-diagram.png)

## Project Components

### 1. **Terraform**
   - **S3**: The resume website is hosted in an S3 bucket configured for static website hosting.
   - **CloudFront**: A CloudFront distribution is used to deliver the content with low latency and high transfer speeds.
   - **Route 53**: DNS management is handled via Route 53, pointing to the CloudFront distribution.
   - **DynamoDB**: Used for state locking

### 2. **GitHub Actions**
   - **Terraform Plan & Apply**: Automatically triggers Terraform to plan and apply changes when updates are pushed to the repository.
   - **Linting**: Ensures Terraform code follows best practices.
   - **S3 Sync**: Automates the deployment of website files to the S3 bucket.

### 3. **AWS Services**
   - **S3**: Static site hosting.
   - **CloudFront**: Content delivery network (CDN) for the site.
   - **Route 53**: DNS configuration.
   - **DynamoDB**: Used for state locking.

## Prerequisites

Before you begin, ensure you have the following:

- **Terraform**: Installed on your local machine.
- **AWS CLI**: Configured with your AWS credentials.
- **GitHub Account**: For version control and CI/CD.
- **Domain Name**: Registered in Route 53 (optional but recommended).
