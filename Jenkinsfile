//Define Variables
def buildNumber= BUILD_NUMBER
pipeline {
    agent any
    stages {
        stage('SCM Checkout') {
            steps {
                git 'https://github.com/dgp999/MyDominos.git'
            }
        }
        stage('Build && SonarQube Analysis'){
            steps {
                withSonarQubeEnv('SonarQube-Server') {
                    sh 'mvn clean package sonar:sonar'
                }
            }
        }
        stage('Building Docker Image') {
            steps {
                sh "docker build -t dgpdevops/mydockerapp:${buildNumber} ."
            }
        }
        stage('Uploading image to DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub_cred', variable: 'dockerhub_newcred')]) {
                    sh "docker login -u dgpdevops -p ${dockerhub_newcred}"
                    sh "docker push dgpdevops/mydockerapp:${buildNumber}"
                }
            }
        }
        stage('Deploying Container On Dev Server') {
            agent any
            steps {
                sshagent(['docker-slave2']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@172.31.0.208 docker stop webappcontainer || true
                    ssh -o StrictHostKeyChecking=no ubuntu@172.31.0.208 docker rm -f webappcontainer || true
                    ssh -o StrictHostKeyChecking=no ubuntu@172.31.0.208 docker run -d -p 8080:8080 --name webappcontainer dgpdevops/mydockerapp:${buildNumber}
                    """
                }
            }
        }
        stage('Slack Notification') {
            steps {
                slackSend baseUrl: 'https://hooks.slack.com/services/', 
                channel: 'bankingapp', color: 'good', 
                message: 'Hello All.... Deployment is Completed on Dev Env Successfully', 
                teamDomain: 'devopsteam', tokenCredentialId: 'slack', 
                username: 'gourip092@gmail.com'
            }
        }
        stage('Dev Approval') {
            steps {
                echo "Taking Approval from Dev Manager for QA Deployment"
                timeout(time: 30, unit: 'SECONDS') {
                    input message: 'Do you want to deploy', submitter: 'admin'
                }
            }
        }
        stage('QA Deployment') {
            steps {
                echo "Deployment on QA Env"
            }
        }
    }
}
