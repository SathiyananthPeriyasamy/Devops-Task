pipeline {
    agent {
        label 'docker-slave'
    }

    environment {
        TOMCAT_IP = '172.31.33.1'
        TOMCAT_PATH = '/var/lib/tomcat10/webapps/'
        IMAGE_NAME = 'fortask-app'
        CONTAINER_NAME = 'fortask-container'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master',
                url: 'https://github.com/SathiyananthPeriyasamy/Devops-Task.git'
            }
        }

        stage('Build Maven') {

            steps {

                sh 'java -version'
                sh 'mvn -version'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Verify Artifact') {

            steps {

                sh 'ls -lh target/'
            }
        }

        stage('Build Docker Image') {

            steps {

                sh """
                docker build -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Stop Old Container') {

            steps {

                sh """
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true
                """
            }
        }


stage('Run Docker Container') {
            steps {
                sh "docker run -d --name ${CONTAINER_NAME} -p 8090:8080 ${IMAGE_NAME}:latest"
            }
        }

        stage('Verify Container') {

            steps {

                sh 'docker ps'
            }
        }

        stage('Deploy to Remote Tomcat') {

            steps {

                sshagent(credentials: ['ubuntu']) {

                    sh """
                    scp -o StrictHostKeyChecking=no \
                    target/*.war \
                    ubuntu@${TOMCAT_IP}:${TOMCAT_PATH}myapp.war
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded! Sending email...'
            mail to: 'sathiyacse1@gmail.com',
                 subject: "SUCCESS: Jenkins Pipeline ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Great news! Your Tomcat application deployed successfully.\n\nView the run details here: ${env.BUILD_URL}"
        }
        failure {
            echo 'Pipeline failed! Sending email...'
            mail to: 'sathiyacse1@gmail.com',
                 subject: "FAILED: Jenkins Pipeline ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Uh oh. Something went wrong during the build or deployment.\n\nPlease check the Jenkins console logs here: ${env.BUILD_URL}"
        }
        always {
            echo 'Pipeline completed.'
        }
    }
}
