# URL Shortener

This project implements a URL shortening service using Go, DynamoDB, ECS, and Terraform.

![image](https://github.com/user-attachments/assets/7f3059a3-97e9-4aa3-8787-3fe9d5c1bc4c)

## Table of Contents

- [Architecture](#architecture)
- [Terraform Project](#terraform-project)
  - [Modules](#modules)
    - [vpc](#module-vpc)
    - [iam](#module-iam)
    - [dynamodb](#module-dynamodb)
    - [ecs](#module-ecs)
    - [ec2](#module-ec2)
- [Go Server Routes](#go-server-routes)
  - [POST /shorten](#post-apishorten)
  - [GET /long-url/{shortURL}](#get-short_code)
- [URL Shortening Algorithm](#url-shortening-algorithm)

## Architecture

The application is deployed on AWS and utilizes the following services:

- **ECS (Elastic Container Service):** Runs the Go server as a containerized application.
- **EC2 (Elastic Compute Cloud):** Provides the underlying virtual machines for the ECS cluster.
- **DynamoDB:** Stores the mapping between short codes and original URLs.
- **ALB (Application Load Balancer):** Distributes incoming traffic to the ECS service.

## Terraform Project

The Terraform project is responsible for provisioning and managing the infrastructure for the URL shortening service.

### Modules

The project is organized into several modules:

#### Module: vpc

This module defines the VPC (Virtual Private Cloud) network infrastructure, including:

- VPC with a specified CIDR block.
- Public subnets for internet-facing resources.
- Security groups for controlling network traffic.

#### Module: iam

This module manages the IAM (Identity and Access Management) roles and policies required for the application, including:

- ECS task execution role for allowing ECS tasks to access other AWS resources.
- ECS instance role for granting permissions to EC2 instances running ECS tasks.

#### Module: dynamodb

This module provisions the DynamoDB table used to store the URL mappings.

#### Module: ecs

This module defines the ECS cluster, task definition, and service for running the Go server. It configures:

- ECS cluster for grouping and managing ECS tasks.
- ECS task definition specifying the container image, environment variables, and resource limits for the Go server.
- ECS service for ensuring the desired number of tasks are running and registered with the load balancer.

#### Module: ec2

This module provisions the EC2 instances that will run the ECS tasks. It configures:

- Auto Scaling group for dynamically adjusting the number of EC2 instances based on demand.
- EC2 instances with the required instance type, security groups, and IAM role.

## Go Server Routes

The Go server exposes the following API routes:

### POST /shorten

This route accepts a JSON payload with the original URL and returns a short code.

**Request Body:**

```json
{
  "long_url": "https://www.example.com/long-url"
}
```

Response Body:

```json
{
  "short_url": "short"
}
```

### GET /long-url/{shortURL}
This route redirects the user to the original URL associated with the provided short code.

### URL Shortening Algorithm

The ShortenURL function generates a short code for a given URL using a CRC32 checksum and hexadecimal conversion. Here's a breakdown:

- Hashing:
  - It utilizes the crc32.NewIEEE() function to create a new CRC32 checksum using the IEEE polynomial. CRC32 is a non-cryptographic hash function known for its speed and relatively low collision rates.
The code calculates the checksum of the input longUrl by feeding its byte representation into the hasher using hasher.Write([]byte(longUrl)).

- Hexadecimal Conversion:
  - hasher.Sum32() computes the final 32-bit checksum of the input URL.
fmt.Sprintf("%x", ...) formats the obtained 32-bit checksum into a hexadecimal string representation.
In essence: The function takes a long URL, computes its CRC32 checksum, and returns the hexadecimal representation of that checksum as the short code.
