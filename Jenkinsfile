pipeline {
    agent any

    environment {
    APP_NAME = 'CalculatorApp'
    }

    tools {
            maven 'MVN3'  // Configure this in Jenkins Global Tool Configuration
        }
    stages {
        stage('Initialize') {
            steps {
                echo "Application: ${APP_NAME}"
                echo "Build Number: ${BUILD_NUMBER}"
            }
        }

        stage('Checkout') {
            steps {
                // checkout scm  // For Git-based projects
                sh 'ls -la'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
//             when {
//                 expression { params.SKIP_TESTS == false }
//             }
            steps {
                    sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
    }
}