pipeline {
    agent any

    environment {
        IMAGE_NAME = "kadia08/springboot_app"
        JAVA_VERSION = "21"
        SERVICE_ID = "srv-d3729sre5dus738uujng"
        RENDER_API_KEY   = "rnd_lJ9xjDi2XB4kg9F0FdD3kr2gziZC" // API
    }
// https://api.render.com/deploy/srv-d3729sre5dus738uujng?key=E5_N-dKNaeA
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

        //  stage('Deploy to Render') {
        //     steps {
        //         sh """
        //           curl -X POST https://api.render.com/deploy/${RENDER_SERVICE_ID} \
        //           -H "Accept: application/json" \
        //           -H "Authorization: Bearer ${RENDER_API_KEY}"
        //         """
        //     }
        // }

//   stage('Deploy to Render') {
//     steps {
//         script {
//             // Create the JSON file safely
//             // writeFile file: 'payload.json', text: """{
//             //   "serviceId": "${RENDER_SERVICE_ID}",
//             //   "clearCache": true
//             // }"""

//             // Call the Render Deploy API
//          sh """
//             curl -s -w '\\nHTTP %{http_code}\\n' -X POST \
//                 -H "Authorization: Bearer ${RENDER_API_KEY}" \
//                 -H "Content-Type: application/json" \
//                 -d '{\"serviceId\":\"${SERVICE_ID}\",\"clearCache\":true}' \
//                 https://api.render.com/v1/services/${SERVICE_ID}/deploys
//             """

//         }
//     }
//        }  


        stage('Deploy to Render') {
            steps {
                script {
                    writeFile file: 'payload.json', text: """{
                        "clearCache": true
                    }"""

                  sh """
                    curl -s -w '\\nHTTP %{http_code}\\n' -X POST \
                        -H "Authorization: Bearer ${env.RENDER_API_KEY}" \
                        -H "Content-Type: application/json" \
                        --data-binary @- \
                        https://api.render.com/v1/services/${SERVICE_ID}/deploys <<'EOF'
                    {
                    "serviceId": "${SERVICE_ID}",
                    "clearCache": true
                    }
                    EOF
                    """
                }
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
                   docker run -d --name springboot_app -p 8082:8081 $IMAGE_NAME:${env.BUILD_NUMBER}
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
