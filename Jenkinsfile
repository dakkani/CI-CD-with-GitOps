pipeline {
    agent any

    options {
        timeout(time: 1, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timestamps()
    }

    environment {
        DOCKERHUB_USERNAME       = 'omer2k1'
        DOCKERHUB_CREDENTIALS_ID = 'dockerhub-credentials'
        DOCKERHUB_REPOS          = 'omer2k1/java-web-app'
        GIT_MANIFESTS_REPO       = 'https://github.com/dakkani/gitops-argocd-java-app.git'
        PATH                     = "${HOME}/.local/bin:${PATH}"
    }

    stages {
        stage('Checkout Application Code') {
            steps {
                echo 'Checking out source...'
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'main']],
                    userRemoteConfigs: [[url: 'https://github.com/dakkani/CI-CD-with-GitOps.git']]
                ])
            }
        }

        stage('Build and Unit Tests') {
            steps {
                echo 'Building and running unit tests...'
                sh 'mvn clean install -B'
            }
        }

        stage('Static Analysis (Semgrep)') {
            steps {
                echo 'Running Semgrep static analysis...'
                sh '''
                    python3 -m pip install --user semgrep
                    ~/.local/bin/semgrep scan --config p/java --error
                '''
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    echo 'Building Docker image...'
                    def imageTag = env.BUILD_NUMBER
                    def imageName = "${env.DOCKERHUB_REPOS}:${imageTag}"
                    env.DEPLOY_IMAGE = imageName
                    docker.build(imageName, ".")
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    echo "Pushing Docker image to Docker Hub: ${env.DEPLOY_IMAGE}"
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKERHUB_CREDENTIALS_ID) {
                        docker.image(env.DEPLOY_IMAGE).push()
                    }
                }
            }
        }

        stage('Update GitOps Repository') {
            steps {
                echo 'Updating Kubernetes manifests in GitOps repo...'
                withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                    dir('k8s-manifests') {
                        sh """
                            git clone https://github.com/dakkani/gitops-argocd-java-app.git .
                            git config user.email "jenkins@example.com"
                            git config user.name "Jenkins CI"
                            sed -i "s|image: ${DOCKERHUB_REPOS}:.*|image: ${DEPLOY_IMAGE}|g" deployment.yaml
                            git add deployment.yaml
                            git commit -m "Update image to ${DEPLOY_IMAGE} [skip ci]" || echo "No changes to commit"
                            git push https://\$GITHUB_TOKEN@github.com/dakkani/gitops-argocd-java-app.git main
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished. Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Build successful!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
