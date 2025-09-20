pipeline {
    agent any


    stages {





        stage('Push to DockerHub') {
            steps {

                    sh "echo beguee Bab's "
            }
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
