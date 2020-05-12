pipeline {
    agent any
    stages {
        stage ('SCM Checkout') {
            steps {
                git 'https://github.com/dgp999/MyDominos.git'
            }
        }
        stage('Build && SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube-Server') {
                    sh 'mvn clean package sonar:sonar'
                }
            }
        }
        stage('Building Docker Image') {
            steps {
                sh "docker build -t dgpdevops/mydockerapp ."
            }
        }
        stage('Uploading Artifact') {
           steps {
              script { 
                 def server = Artifactory.server 'artfact1'
                 def uploadSpec = """{
                    "files": [{
                       "pattern": "target/mywebapp.war",
                       "target": "mymaven/"
                    }]
                 }"""
                 server.upload(uploadSpec)
              }
           }
        }
    }
}
