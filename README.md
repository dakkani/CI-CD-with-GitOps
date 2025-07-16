# Jenkins CI/CD Pipeline Template

This project provides a **CI/CD pipeline** integrating **Jenkins**, **Maven**, **Semgrep**, **Docker**, **Git**, and **GitHub** for building, testing, scanning, and packaging Java applications. The pipeline is designed to automate the process from code commit to Docker image building, security scanning, and deployment artifact updates, enabling a best-practices DevSecOps workflow.

> The Kubernetes deployment and GitOps continuation of this pipeline is available at:  
> [gitops-argocd-java-app](https://github.com/dakkani/gitops-argocd-java-app.git)

---

## Features

- **Source Integration**: Pulls code from GitHub.
- **Build & Test**: Uses Maven for build, dependency management, and running tests.
- **Security Analysis**: Integrates Semgrep for static code analysis.
- **Containerization**: Builds Docker images of the Java application.
- **Continuous Delivery**: Pushes images to a container registry and updates Kubernetes manifests via GitOps (see the linked continuation project).

---

## Prerequisites

Ensure the following **software is installed** on the Jenkins host:
- **Java (JDK 11 or higher)**
- **Python (for Semgrep)**
- **Jenkins**
- **Docker** (latest stable)
- **Maven**
- **Git**

Add the Jenkins user to the Docker group to allow container build and push:

```
bash
sudo usermod -aG docker jenkins
```


After running the command, **restart Jenkins** or log out and back in for group changes to take effect.

---

## GitHub Setup

1. **Create a Personal Access Token**:
   - Go to *GitHub ➔ Settings ➔ Developer settings ➔ Personal access tokens (classic)*.
   - Generate a new token with at least `repo` scope for accessing and updating repositories and manifests.

2. **Fork and Create Repositories**:
   - **Fork this repository** to your own GitHub account.
   - **Create a new repository** for storing your Kubernetes manifests.

3. **Configure Jenkins Credentials**:
   - Add your GitHub token in Jenkins as a secret credential, referenced by the pipeline job.

---

## Usage

1. **Pipeline Configuration**:
   - Clone this repo and adapt the Jenkinsfile for your environment (`repo URLs`, `docker registry`, credentials IDs, etc.).
   - Configure required environment variables/secrets in Jenkins.

2. **Typical Pipeline Steps**:
   - `checkout`: Clone code from GitHub.
   - `build`: Use Maven to compile and test.
   - `scan`: Run Semgrep for code scanning.
   - `dockerize`: Build and tag Docker image.
   - `push`: Push Docker image to container registry.
   - `update manifests`: (see gitops-argocd-java-app) Update Kubernetes manifests repo with new image tag.

---

## Extending with Kubernetes and GitOps

- To enable **automated deployments** via Kubernetes, integrate this pipeline with the manifests and patterns in [gitops-argocd-java-app](https://github.com/dakkani/gitops-argocd-java-app.git).
- This enables **end-to-end automation** from code commit through containerization to Kubernetes deployment using Argo CD.

---

## Contribution & Support

- Fork and open PRs for improvements.
- Issues and questions are welcome via GitHub Issues.

---

**Note:** Jenkins must run with Docker access for building and pushing images, and your GitHub tokens/credentials must be securely managed within Jenkins.
