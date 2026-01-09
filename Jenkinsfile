pipeline {
    agent any

    tools {
            maven 'MVN3'  // Configure this in Jenkins Global Tool Configuration
        }
    stages {
        stage('Build') {
            steps {
                sh 'mvn compile'
            }
        }
    }
}