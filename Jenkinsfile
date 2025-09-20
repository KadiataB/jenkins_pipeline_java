pipeline {
    agent any

    environment {
        IMAGE_NAME      = "kadia08/springboot_app"
        JAVA_VERSION    = "21"
        SERVICE_ID      = "srv-d3729sre5dus738uujng"
        // Replace with your own Render Deploy Hook URL (Service → Manual Deploy → Deploy Hook)
        RENDER_DEPLOY_HOOK_URL = "https://api.render.com/deploy/srv-d3729sre5dus738uujng?key=E5_N-dKNaeA" // Secret Text in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/KadiataB/jenkins_pipeline_java.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh "./mvnw clean package -DskipTests"
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
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push $IMAGE_NAME:${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy to Render') {
            steps {
                script {
                    def imgUrl = "docker.io/${IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh """
                       echo "Triggering Render deploy for image: ${imgUrl}"
                       curl -s -w '\\nHTTP %{http_code}\\n' -X POST \
                            "${RENDER_DEPLOY_HOOK_URL}?imgURL=${imgUrl}"
                    """
                }
            }
        }

        stage('Debug (Optional)') {
            steps {
                sh 'pwd'
                sh 'ls -l'
                sh 'whoami'
                sh 'java -version'
                sh 'docker version || true'
                sh 'docker info || true'
            }
        }
    }

    post {
        success {
            echo "✅ Deployment to Render successful!"
        }
        failure {
            echo "❌ Deployment failed."
        }
    }
}
