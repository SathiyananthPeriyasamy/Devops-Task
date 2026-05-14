pipeline {
    agent {
        // This forces the job to run on Node 2 using the label we set up!
        label 'node2-slave' 
    }

    environment {
        // We will configure this credential in the Jenkins UI in Phase 4
        DOCKERHUB_CREDS = credentials('dockerhub-credentials')
        
        // IMPORTANT: Change 'your-dockerhub-username' to your actual DockerHub username!
        IMAGE_NAME = "sathiyananth/tomcat-hello-world" 
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                echo 'Compiling and building the WAR file...'
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker Image from Dockerfile...'
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                sh "docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest"
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo 'Logging into DockerHub and pushing image...'
                sh "echo \$DOCKERHUB_CREDS_PSW | docker login -u \$DOCKERHUB_CREDS_USR --password-stdin"
                sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                sh "docker push ${IMAGE_NAME}:latest"
            }
        }
    }
}
