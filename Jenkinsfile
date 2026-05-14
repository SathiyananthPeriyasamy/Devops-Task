pipeline {

    agent {
        label 'docker-slave'
    }

    environment {

        TOMCAT_IP = '34.202.9.236'
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

                sh """
                docker run -d \
                --name ${CONTAINER_NAME} \
                -p 8090:8080 \
                ${IMAGE_NAME}:latest
                """
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
                    ubuntu@${TOMCAT_IP}:${TOMCAT_PATH}mywar.war
                    """
                }
            }
        }
    }

    post {

        always {

            echo 'Pipeline completed.'
        }
    }
}
