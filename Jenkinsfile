pipeline {
    agent any

    tools {
            maven 'Maven-3.9'  // Configure this in Jenkins Global Tool Configuration
        }
    stages {
        stage('Build') {
            steps {
                sh 'mvn compile'
            }
        }
    }
}