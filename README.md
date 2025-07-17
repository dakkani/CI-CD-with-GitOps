# 🚀 Jenkins CI/CD Pipeline for Java Web App

This project provides a simple and effective CI/CD pipeline for your Java web applications. Using a combination of Jenkins, Maven, Semgrep, and Docker, it automates the process of building, testing, scanning, and packaging your app. When you're ready to deploy, this pipeline can push your Docker images to a registry, and for Kubernetes deployment and GitOps, you can check out our gitops project: [gitops-argocd-java-app](https://github.com/dakkani/gitops-argocd-java-app.git).

---

## ✨ Features

*   📥 **Code Checkout:** Automatically pulls your latest code from GitHub.
*   🛠️ **Build & Test:** Uses Maven to build and run your tests.
*   🔍 **Code Analysis:** Scans your code for vulnerabilities with Semgrep.
*   📦 **Docker Images:** Builds your application into a Docker image.
*   🚢 **Push to Registry:** Pushes the built image to a container registry.
*   ⛵ **Kubernetes Ready:** Supports GitOps-based Kubernetes deployments through our continuation project.

---

## 🛠️ Prerequisites

Before you begin, make sure you have the following installed on your Jenkins server:

*   ☕ **Java (JDK 17+):** The engine for your Java application.
*   🐍 **Python:** Required for running Semgrep.
*   🤖 **Jenkins:** The heart of our CI/CD pipeline.
*   🐳 **Docker:** For building and managing your containers.
*   🏗️ **Maven:** To build and manage your Java project.
*   🐙 **Git:** For version control and pulling code from GitHub.

Additionally, you'll need to give the Jenkins user access to Docker. You can do this by running:

```bash
sudo usermod -aG docker jenkins
```

After running the command, don't forget to restart Jenkins or log out and back in for the changes to take effect.

---

## 🐙 GitHub Setup

1.  **Personal Access Token:** Create a new token with `repo` scope. You can do this in your GitHub account under **Settings ➔ Developer settings ➔ Personal access tokens**.
2.  **Repositories:** Fork this repository and, if you plan to use Kubernetes, create another repository for your manifests.
3.  **Jenkins Credentials:** Add your GitHub token to Jenkins as a secret credential so it can securely access your repositories.

---

## 🚀 Usage

1.  **Clone the Repo:** Start by cloning this repository and updating the `Jenkinsfile` to match your environment (e.g., URLs, registry, credentials).
2.  **Set Secrets:** Make sure to set all the necessary secrets in Jenkins.
3.  **Pipeline Steps:**
    *   📥 **Checkout:** Grabs your code from GitHub.
    *   🛠️ **Build & Test:** Compiles and tests your code with Maven.
    *   🔍 **Scan:** Analyzes your code with Semgrep.
    *   📦 **Build & Tag:** Creates and tags your Docker image.
    *   🚢 **Push:** Pushes the image to your container registry.
    *   📝 **Update Manifests:** For Kubernetes deployment, check out our [gitops-argocd-java-app](httpsin://github.com/dakkani/gitops-argocd-java-app.git) project.

---

## ⛵ Extending with Kubernetes & GitOps

To take your deployment to the next level, integrate this pipeline with our [gitops-argocd-java-app](https://github.com/dakkani/gitops-argocd-java-app.git) project. This will allow you to set up automated Kubernetes deployments with Argo CD.

---

## 🙌 Contribution & Support

*   **Contribute:** Feel free to fork this repository and submit pull requests for any improvements.
*   **Get Help:** If you have any questions or run into any problems, please open an issue.

---

**🔒 Note:** Remember that Jenkins needs access to Docker, and your GitHub tokens should always be managed securely in Jenkins.

---
