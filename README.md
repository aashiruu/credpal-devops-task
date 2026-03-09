# CredPal DevOps Engineer Assessment

## Overview
This project demonstrates a production-ready DevOps pipeline for a simple Node.js application. The goal is to showcase best practices for containerization, CI/CD automation, infrastructure provisioning, and deployment strategies.

The application exposes three endpoints and runs on port 3000.

Endpoints:
- GET /health – Returns application health status.
- GET /status – Returns application readiness status.
- POST /process – Simulates processing incoming data.

## How to Run the Application Locally

### Prerequisites
- Docker
- Docker Compose

### Start the Services
Run the following command in the root directory:
```
docker-compose up --build -d
```
This will start the Node.js application on port 3000 and a PostgreSQL database in the background.

## How to Access the App
The application exposes three main endpoints. You can access them via your browser or terminal:
```
Endpoint,Method,Description
http://localhost:3000/health,GET,Returns application health status
http://localhost:3000/status,GET,Returns readiness and environment info
http://localhost:3000/process,POST,Simulates data processing
```

Quick Test Commands:

# Health check
```
curl http://localhost:3000/health
```
# Status check
```
curl http://localhost:3000/status
```
# Process data
```
curl -X POST http://localhost:3000/process -H "Content-Type: application/json" -d '{"data":"test"}'
```
## How to Deploy the Application
### Infrastructure Provisioning
The infrastructure is defined using Terraform in the ``` /terraform ``` directory.

Navigate to the folder: ``` cd terraform ```
Initialize : ``` terraform init ```
Plan/Apply : ``` terraform apply ```
This provisions a VPC, Security Groups, an Application Load Balancer, and an EC2 instance.

### Deployment Flow
The application follows a Rolling Deployment strategy to ensure Zero-Downtime:

**Build** : GitHub Actions builds a new Docker image on every push to ``` main ```.
**Push** : The image is pushed to the container registry.
**Update** : The deployment script (or orchestrator) triggers a rolling update, replacing old containers with new ones only after they pass the defined health checks.

## Key Technical Decisions
### Security
**Non-Root Execution**: The Dockerfile creates and switches to ```nodeuser```. The application never runs with root privileges, significantly reducing the risk of container breakout.
**Minimal Surface Area**: Used ```node:18-alpine``` as the base image to minimize vulnerabilities and optimize build speed.
**Secrets Management**: Environment variables are used in ```docker-compose.yml``` to decouple configuration from code.
**HTTPS**: The Terraform configuration includes a Load Balancer setup designed to terminate SSL/TLS certificates

### CI/CD (GitHub Actions)
**Automated Validation**: The pipeline (found in ``` .github/workflows/main.yml ``` ) automates the environment setup, dependency installation, and Docker build.
**Build Consistency**: By performing the build in the CI environment, we ensure that the image is identical across development, staging, and production.

### Infrastructure
**VPC Isolation**: Implemented a Virtual Private Cloud with specific ingress rules, ensuring that only necessary ports (3000, 80, 443) are exposed to the public internet.
**Health Monitoring**: Integrated Docker ``` HEALTHCHECK ``` within the container to allow the load balancer to automatically drain traffic from unhealthy instances.

## Architecture Diagram

<img width="745" height="1239" alt="mermaid-diagram-2026-03-09-222630" src="https://github.com/user-attachments/assets/8e1822d5-aed4-4679-95a9-08627249e978" />

## Future Improvements
Implement **Prometheus/Grafana** for deeper observability.
Transition to **Kubernetes (EKS)** for advanced orchestration.
Add a Manual Approval gate in **GitHub Actions** for production deployments.
