# Jenkins CI/CD Pipeline for Java Web App

This project sets up a simple CI/CD pipeline for Java web applications using Jenkins, Maven, Semgrep, Docker, and GitHub. It builds, tests, scans, and packages your app, then pushes Docker images to a registry. For Kubernetes deployment and GitOps, see: [gitops-argocd-java-app](https://github.com/dakkani/gitops-argocd-java-app.git)

---

## Features

- Pulls code from GitHub
- Builds & tests with Maven
- Runs static code analysis with Semgrep
- Builds Docker images
- Pushes images to a container registry
- Supports GitOps-based Kubernetes deployments (see continuation project)

---

## Prerequisites

Install these on your Jenkins server:
- Java (JDK 11+)
- Python (for Semgrep)
- Jenkins
- Docker
- Maven
- Git

Add Jenkins user to the Docker group:
```bash
sudo usermod -aG docker jenkins
```
Restart Jenkins or log out/in after running the command.

---

## GitHub Setup

1. **Personal Access Token:** Create one with `repo` scope (GitHub ➔ Settings ➔ Developer settings ➔ Personal access tokens).
2. **Repositories:** Fork this repo and create another repo for Kubernetes manifests.
3. **Jenkins Credentials:** Add your GitHub token to Jenkins as a secret credential.

---

## Usage

1. Clone this repo and update the Jenkinsfile for your environment (URLs, registry, credentials, etc).
2. Set necessary secrets in Jenkins.
3. Pipeline steps:
   - Checkout code
   - Build & test (Maven)
   - Scan code (Semgrep)
   - Build & tag Docker image
   - Push image to registry
   - Update manifests (see [gitops-argocd-java-app](https://github.com/dakkani/gitops-argocd-java-app.git))

---

## Extending with Kubernetes & GitOps

- Integrate with [gitops-argocd-java-app](https://github.com/dakkani/gitops-argocd-java-app.git) for automated Kubernetes deployments with Argo CD.

---

## Contribution & Support

- Fork and submit PRs for improvements.
- Open issues for questions or problems.

---

**Note:** Jenkins needs Docker access, and GitHub tokens should be securely managed in Jenkins.

---
