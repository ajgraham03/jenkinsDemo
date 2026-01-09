pipeline {
    agent any

    environment {
    APP_NAME = 'calculator-app'
    DOCKER_IMAGE = "${APP_NAME}"
    DOCKER_TAG = "${BUILD_NUMBER}"
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

            steps {
                    sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Package') {
            steps {
                    sh 'mvn package -DskipTests -B'
                }
        }

        stage('Code Quality') {
            parallel {
                stage('Lint Check') {
                    steps {
                        echo 'Running linter...'
                    }
                }
                stage('Security Scan') {
                    steps {
                        echo 'Running security scan...'
                    }
                }
            }
        }

        stage('Build Docker Image') {

            steps {

                    sh '''
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                    '''

            }
        }
    }
}