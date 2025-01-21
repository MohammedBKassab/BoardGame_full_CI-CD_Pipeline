pipeline {
    agent any
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }

    environment {
        Scanner_Home = tool 'sonar-scanner'
        DOCKER_IMAGE = "boardgame"
        K8S_NAMESPACE = "webapps"
        SONAR_LOGIN = credentials('sonar-token')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', credentialsId: 'git-token', url: 'https://github.com/MohammedBKassab/BoardGame_full_CI-CD_Pipeline.git'
            }
        }

        stage('Compile Code & Run Tests') {
            steps {
                script {
                    withMaven(maven: 'maven3') {
                        sh 'mvn compile'
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('Vulnerability Scan') {
            steps {
                script {
                    sh 'trivy fs --format table -o vulnerabilities_filesystem.html .'
                    archiveArtifacts artifacts: 'vulnerabilities_filesystem.html', allowEmptyArchive: true
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv(installationName: 'sonar-server', credentialsId: 'sonar-token') {
                    sh '''
                        ${Scanner_Home}/bin/sonar-scanner \
                        -Dsonar.projectKey=BoardGame \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://18.234.224.84:9000 \
                        -Dsonar.login=${SONAR_LOGIN} \
                        -Dsonar.java.binaries=.
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false , credentialsId: 'sonar-token'
                }
            }
        }

        stage('Build Package') {
            steps {
                sh "mvn package"
            }
        }

        stage('Push Artifact to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-settings', maven: 'maven3') {
                    sh 'mvn deploy'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t mooo653/${DOCKER_IMAGE}:latest ."
                }
            }
        }

        stage('Scan Docker Image') {
            steps {
                script {
                    sh "trivy image mooo653/${DOCKER_IMAGE}:latest --format table -o vulnerabilities_docker.html"
                    archiveArtifacts artifacts: 'vulnerabilities_docker.html', allowEmptyArchive: true
                }
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                script {
                    withDockerRegistry( credentialsId: 'docker-cred') {
                        sh "docker push mooo653/${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig(
                    credentialsId: 'k8s-cred',
                    namespace: "${K8S_NAMESPACE}",
                    serverUrl: 'https://172.31.19.88:6443'
                ) {
                    sh "kubectl apply -f deployment.yaml"
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                withKubeConfig(
                    credentialsId: 'k8s-cred',
                    namespace: "${K8S_NAMESPACE}",
                    serverUrl: 'https://172.31.19.88:6443'
                ) {
                    sh "kubectl get pods -n webapps"
                    sh "kubectl get svc -n webapps"
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline execution completed."
        }

        success {
            echo "Pipeline executed successfully!"
            mail to: 'medokassab07@gmail.com', 
                 subject: "Successful Build: ${env.JOB_NAME}", 
                 body: "The Jenkins job '${env.JOB_NAME}' has been successfully executed. Build URL: ${env.BUILD_URL}"
        }

        failure {
            echo "Pipeline failed. Please check logs for errors."
            mail to: 'medokassab07@gmail.com', 
                 subject: "Failed Build: ${env.JOB_NAME}", 
                 body: "The Jenkins job '${env.JOB_NAME}' has failed. Build URL: ${env.BUILD_URL}"
        }
    }
}
