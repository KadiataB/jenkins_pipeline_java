pipeline {
    agent any

    environment {
        IMAGE_NAME = "kadia08/springboot_app"
        JAVA_VERSION = "21"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/KadiataB/jenkins_pipeline_java.git'

            }
        }

        stage('Build with Maven') {
            steps {
                // Utilise Maven Wrapper si présent
                sh "./mvnw clean package -DskipTests"
                // Sinon
                // sh "mvn clean package -DskipTests"
            }
        }

        stage('Debug') {
            steps {
                script {
                    sh 'pwd'
                    sh 'ls -l'
                    sh 'whoami'
                    sh 'java -version'
                    sh 'docker version || true'
                    sh 'docker info || true'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                   docker build -t $IMAGE_NAME:${env.BUILD_NUMBER} .
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push $IMAGE_NAME:${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy') {
            steps {
                sh """
                   docker stop springboot_app || true
                   docker rm springboot_app || true
                   docker run -d --name springboot_app -p 8082:8080 $IMAGE_NAME:${env.BUILD_NUMBER}
                """
            }
        }
    }

    post {
        success {
            echo "Déploiement réussi 🎉"
        }
        failure {
            echo "Erreur lors du déploiement ❌"
        }
    }
}
