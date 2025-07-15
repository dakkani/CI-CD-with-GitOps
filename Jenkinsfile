pipeline {
    agent {
        docker {
            image 'maven:3.8.6-openjdk-17'
            args '-v /root/.m2:/root/.m2' // Mount Maven local repository for caching
        }
    }

    environment {
        // DockerHub credentials (configured in Jenkins as 'dockerhub-credentials')
        DOCKERHUB_USERNAME = 'your_dockerhub_username' // Replace with your DockerHub username
        DOCKERHUB_CREDENTIALS_ID = 'dockerhub-credentials'

        // Git repository for Kubernetes manifests (where ArgoCD pulls from)
        GIT_MANIFESTS_REPO = 'git@github.com:your_org/your_k8s_manifests_repo.git' // Replace with your manifests repo
        GIT_MANIFESTS_CREDENTIALS_ID = 'git-ssh-credentials' // Jenkins SSH credentials for the manifests repo

        // SonarQube credentials (configured in Jenkins as 'sonarqube-credentials')
        SONAR_CREDENTIALS_ID = 'sonarqube-credentials'

        // Email recipients for notifications
        EMAIL_RECIPIENTS = 'your_email@example.com' // Replace with actual email addresses
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo 'Checking out SCM...'
                checkout scm
            }
        }

        stage('Build and Test') {
            steps {
                echo 'Building and running tests...'
                sh 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo 'Running SonarQube analysis...'
                withCredentials([string(credentialsId: env.SONAR_CREDENTIALS_ID, variable: 'SONAR_TOKEN')]) {
                    sh "mvn sonar:sonar -Dsonar.login=\"${SONAR_TOKEN}\"
                }
            }
        }

        stage('Docker Containerization and Push') {
            steps {
                echo 'Building Docker image and pushing to DockerHub...'
                script {
                    def appVersion = sh(returnStdout: true, script: "mvn help:evaluate -Dexpression=project.version -q -DforceStdout").trim()
                    def imageName = "your_dockerhub_username/spring-boot-demo:${appVersion}" // Replace with your DockerHub username

                    withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "docker build -t ${imageName} ."
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        sh "docker push ${imageName}"
                    }
                    // Store the image name for later use in deployment
                    env.DEPLOY_IMAGE = imageName
                }
            }
        }

        stage('Deployment with ArgoCD (via Git)') {
            steps {
                echo 'Updating Kubernetes manifests and pushing to Git for ArgoCD...'
                script {
                    // Clone the manifests repository
                    sh "git config --global user.email 'jenkins@example.com'"
                    sh "git config --global user.name 'Jenkins CI'"
                    sh "git clone ${GIT_MANIFESTS_REPO} k8s-manifests"

                    dir('k8s-manifests') {
                        // Assuming your deployment manifest is at k8s-manifests/deployment.yaml
                        // Replace 'your_app_image' with the actual image name in your manifest
                        sh "sed -i 's|your_dockerhub_username/spring-boot-demo:.*|${env.DEPLOY_IMAGE}|g' deployment.yaml" // Adjust path and image name as needed
                        sh "git add deployment.yaml"
                        sh "git commit -m 'Update spring-boot-demo image to ${env.DEPLOY_IMAGE} [skip ci]'" // [skip ci] to prevent infinite loops
                        withCredentials([sshUserPrivateKey(credentialsId: env.GIT_MANIFESTS_CREDENTIALS_ID, keyFileVariable: 'GIT_SSH_KEY')]) {
                            sh "GIT_SSH_COMMAND='ssh -i ${GIT_SSH_KEY} -o StrictHostKeyChecking=no' git push origin master"
                        }
                    }
                }
            }
        }

        stage('Smoke Test') {
            steps {
                echo 'Running smoke tests...'
                // This is a placeholder. You would typically wait for the deployment to be ready
                // and then hit the application's endpoint.
                // Example: sh 'curl -f http://your-app-url.com/health'
                echo 'Smoke test placeholder: Verify application health after deployment.'
            }
        }

        stage('Rollback') {
            steps {
                echo 'Rollback stage (placeholder)...'
                // This stage would contain logic to revert to a previous stable version
                // In an ArgoCD setup, this might involve reverting the Git commit in the manifests repo
                echo 'Rollback placeholder: Implement logic to revert deployment if needed.'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Build successful!'
            mail to: env.EMAIL_RECIPIENTS,
                 subject: "Jenkins Build Success: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                 body: "The Jenkins build for ${env.JOB_NAME} #${env.BUILD_NUMBER} was successful.\nBuild URL: ${env.BUILD_URL}"
        }
        failure {
            echo 'Build failed!'
            mail to: env.EMAIL_RECIPIENTS,
                 subject: "Jenkins Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                 body: "The Jenkins build for ${env.JOB_NAME} #${env.BUILD_NUMBER} failed.\nBuild URL: ${env.BUILD_URL}"
        }
    }
}