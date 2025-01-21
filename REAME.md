# Continuous Integration and Deployment (CI/CD) Pipeline with Terraform, Jenkins, Kubernetes, and Docker

This repository contains the CI/CD pipeline architecture for a project involving code quality checks, security scans, containerization, and deployment to a Kubernetes cluster. The pipeline utilizes tools such as Jenkins, SonarQube, Aqua Trivy, Docker, and Nexus Repository for seamless automation of application deployment.

## Architecture Overview

### Key Steps in the CI/CD Pipeline:

1. **Developer Workflow**
   - A developer writes code and pushes the changes to a GitHub repository.
   - The pipeline is triggered automatically when new code is pushed.

2. **CI/CD Orchestration with Jenkins**
   - Jenkins orchestrates the pipeline workflow, beginning with fetching the latest code from GitHub.
   - The following steps are performed sequentially:
     - **Compile the Code**: Maven is used to compile the application and run unit tests.
     - **Code Quality Check**: SonarQube analyzes the code for quality.
     - **Vulnerability Scan**: Aqua Trivy scans the code for vulnerabilities.
     - **Package Build**: Maven packages the application, and the artifact is pushed to Nexus Repository.

3. **Containerization and Deployment**
   - A Docker image is built and tagged with a version number.
   - The image undergoes a vulnerability scan with Aqua Trivy.
   - The Docker image is pushed to a container registry (e.g., Docker Hub or private registry).
   - The application is deployed to a Kubernetes cluster.

4. **Post Deployment**
   - The deployment is verified to ensure the application is running as expected.
   - Alerts and logs are monitored using Prometheus and Grafana.

5. **Requirement Management**
   - Feature requests or bug fixes are tracked in a task management tool (e.g., Jira).
   - Any requirement changes are addressed in subsequent iterations of the pipeline.

## Prerequisites

- **Terraform**: To provision the necessary AWS resources.
- **AWS CLI**: Configured with access credentials for resource provisioning.
- **Jenkins**: For CI/CD orchestration.
- **SonarQube**: For code quality analysis.
- **Aqua Trivy**: For vulnerability scanning.
- **Docker**: For containerization.
- **Kubernetes**: For application deployment.
- **Nexus Repository**: To store application artifacts.

## Getting Started

### Step 1: Provision AWS Resources

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repository/project-name.git
   cd project-name
   ```

2. Navigate to the Terraform directory:
   ```bash
   cd terraform
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Apply the Terraform configuration to create AWS resources:
   ```bash
   terraform apply
   ```
   > Review the plan and confirm to create the resources.

### Step 2: Configure Jenkins Pipeline

1. Access the Jenkins dashboard and create a new pipeline job.
2. Point the pipeline configuration to this repository.
3. Configure the pipeline script to execute the steps in the CI/CD pipeline as per the architecture.

### Step 3: Monitor and Deploy

- Use Prometheus and Grafana to monitor system health and logs.
- Ensure that email notifications are configured for pipeline status updates.
- Deployed applications can be accessed via the load balancer or service endpoint exposed by Kubernetes.

## Tools and Technologies Used

- **Terraform**: Infrastructure as Code (IaC) for AWS resource provisioning.
- **Jenkins**: Orchestration of CI/CD pipeline.
- **SonarQube**: Static code analysis and quality management.
- **Aqua Trivy**: Vulnerability scanning for code and Docker images.
- **Docker**: Containerization of applications.
- **Kubernetes**: Deployment and scaling of containerized applications.
- **Nexus Repository**: Artifact storage and management.
- **Prometheus & Grafana**: Monitoring and visualization of pipeline metrics.

## Pipeline Duration

| Step                        | Duration |
|-----------------------------|----------|
| Declarative Tool Install    | 2m       |
| Git Checkout                | 1m       |
| Compile Code                | 2m       |
| File System Scan            | 30s      |
| SonarQube Analysis          | 2m       |
| Quality Gate Validation     | 15s      |
| Build and Push to Nexus     | 2m       |
| Docker Image Build          | 2m       |
| Docker Image Scan           | 1m       |
| Deploy to Kubernetes        | 1m       |
| Verify Deployment           | 15s      |
| Declarative Post Actions    | 1m       |

## Conclusion

This architecture ensures a robust and automated process for deploying applications with high-quality code and secure practices. By leveraging modern tools, the pipeline achieves efficiency and reliability in application delivery.
