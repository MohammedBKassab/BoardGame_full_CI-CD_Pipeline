pipeline {
    agent any
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }

    environment {
        Scanner_Home = tool 'sonar-scanner'
        DOCKER_IMAGE = "BoardGame"
        K8S_NAMESPACE = "webapps"
        
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',credentialsId: 'git-token', url: 'https://github.com/MohammedBKassab/DevOps-Ultimate-CI-CD-Project.git'
            }
        }

        stage('Compile Code & Run Tests') {
            steps {
                script {
                    withMaven(maven: 'maven3') {
                        sh 'mvn  compile '
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('Vulnerability Scan') {
            steps {
                script {
                    sh 'trivy fs --format table -o vulnerabilities.html .'
                }
            }
        }

        stage('Sonarquebe Analysis') {
            steps {
                    withSonarQubeEnv('sonar-token') {
                        sh '''${Scanner_Home}/bin/sonar-scanner  mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=BoardGame \
                        -Dsonar.login=sqp_92a4e001533161f899658cb16a06a3af66d7d958'''

                    } 

                }
            }


        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
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
            withMaven(globalMavenSettingsConfig: 'global-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                sh 'mvn deploy'
            }
            }
        }


        stage('Build Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh "docker build -t mooo653/${DOCKER_IMAGE}:latest ."

                    }
                    
                }
            }
        }

        stage('Scan Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {}
                    sh "trivy image mooo653/${DOCKER_IMAGE}:latest --format table -o vulnerabilities.html "
                }
                }
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                    sh "docker push mooo653/${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig(caCertificate: '', 
                clusterName: 'kubernetes', contextName: '',
                 credentialsId: 'k8s-cred', namespace: 'webapps',
                  restrictKubeConfigAccess: false, serverUrl: 'https://172.31.19.88:6443') {
                    sh "kubectl apply -f deployment.yaml"
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
        }

        failure {
            echo "Pipeline failed. Please check logs for errors."
        }
    }
}
