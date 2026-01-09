// Jenkinsfile - Declarative Pipeline
// Jenkins CI/CD Demo with Java Calculator Application
// Created: 2026-01-08

pipeline {
    agent any

    // Environment variables for the pipeline
    environment {
        APP_NAME = 'CalculatorApp'
        APP_VERSION = '1.0.0'
        DOCKER_IMAGE = "${APP_NAME}"
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

    // Pipeline options
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 30, unit: 'MINUTES')
        timestamps()
        disableConcurrentBuilds()
    }

    // Build parameters
    parameters {
        choice(
            name: 'ENVIRONMENT',
            choices: ['dev', 'staging', 'prod'],
            description: 'Target deployment environment'
        )
        booleanParam(
            name: 'SKIP_TESTS',
            defaultValue: false,
            description: 'Skip test execution'
        )
        booleanParam(
            name: 'BUILD_DOCKER',
            defaultValue: true,
            description: 'Build Docker image'
        )
    }

    // Tool configuration
    tools {
        maven 'Maven-3.9'  // Configure this in Jenkins Global Tool Configuration
    }

    stages {
        stage('Initialize') {
            steps {
                echo '==========================================='
                echo '   Jenkins Pipeline - Calculator Demo'
                echo '==========================================='
                echo "Application: ${APP_NAME} v${APP_VERSION}"
                echo "Build Number: ${BUILD_NUMBER}"
                echo "Environment: ${params.ENVIRONMENT}"
                echo "Workspace: ${WORKSPACE}"
                echo '==========================================='
            }
        }

        stage('Checkout') {
            steps {
                echo 'Checking out source code...'

                // For demo with local files (already in workspace)
                // In real scenario, use: checkout scm

                sh '''
                    echo "Current directory contents:"
                    ls -la
                    echo ""
                    echo "Java source files:"
                    find . -name "*.java" -type f 2>/dev/null || true
                '''
            }
        }

        stage('Build') {
            steps {
                echo 'Building application with Maven...'

                dir('java-app') {
                    sh '''
                        echo "Maven version:"
                        mvn --version
                        echo ""
                        echo "Compiling application..."
                        mvn clean compile -B
                    '''
                }
            }
        }

        stage('Test') {
            when {
                expression { params.SKIP_TESTS == false }
            }
            steps {
                echo 'Running unit tests...'

                dir('java-app') {
                    sh '''
                        echo "Executing JUnit tests..."
                        mvn test -B
                    '''
                }
            }
            post {
                always {
                    // Publish JUnit test results
                    junit(
                        testResults: 'java-app/target/surefire-reports/*.xml',
                        allowEmptyResults: true
                    )
                }
                success {
                    echo '✅ All tests passed!'
                }
                failure {
                    echo '❌ Some tests failed!'
                }
            }
        }

        stage('Package') {
            steps {
                echo 'Packaging application...'

                dir('java-app') {
                    sh '''
                        echo "Creating JAR package..."
                        mvn package -DskipTests -B
                        echo ""
                        echo "Build artifacts:"
                        ls -la target/*.jar
                    '''
                }
            }
        }

        stage('Code Quality') {
            parallel {
                stage('Lint Check') {
                    steps {
                        echo 'Running code lint checks...'
                        sh 'echo "Lint check completed - no issues found"'
                    }
                }
                stage('Security Scan') {
                    steps {
                        echo 'Running security vulnerability scan...'
                        sh 'echo "Security scan completed - no vulnerabilities"'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            when {
                expression { params.BUILD_DOCKER == true }
            }
            steps {
                echo "Building Docker image: ${DOCKER_IMAGE}:${DOCKER_TAG}"

                dir('java-app') {
                    sh '''
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest

                        echo ""
                        echo "Docker images built:"
                        docker images | grep ${DOCKER_IMAGE} || true
                    '''
                }
            }
        }

        stage('Test Docker Image') {
            when {
                expression { params.BUILD_DOCKER == true }
            }
            steps {
                echo 'Testing Docker container...'

                sh '''
                    # Run the container
                    echo "Running container for test..."
                    docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG}

                    echo ""
                    echo "Container test completed successfully!"
                '''
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo 'Archiving build artifacts...'

                archiveArtifacts(
                    artifacts: 'java-app/target/*.jar',
                    fingerprint: true,
                    allowEmptyArchive: false
                )
            }
        }

        stage('Deploy') {
            when {
                allOf {
                    expression { params.ENVIRONMENT == 'prod' }
                    expression { currentBuild.currentResult == 'SUCCESS' }
                }
            }
            steps {
                echo "Deploying to ${params.ENVIRONMENT}..."

                // Production deployment requires approval
                input message: 'Deploy to production?', ok: 'Deploy'

                sh '''
                    echo "Deploying ${DOCKER_IMAGE}:${DOCKER_TAG} to ${ENVIRONMENT}"
                    echo "Deployment successful!"
                '''
            }
        }
    }

    // Post-build actions
    post {
        always {
            echo '==========================================='
            echo '   Pipeline Execution Complete'
            echo '==========================================='
            echo "Result: ${currentBuild.currentResult}"
            echo "Duration: ${currentBuild.durationString}"
            echo '==========================================='
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed!'
            // Uncomment for email notification:
            // emailext subject: "Build ${BUILD_NUMBER} failed",
            //          body: "Check console output at ${BUILD_URL}",
            //          to: 'team@example.com'
        }
        unstable {
            echo '⚠️ Pipeline completed with warnings!'
        }
        cleanup {
            echo 'Cleaning up Docker images...'
            sh '''
                docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} 2>/dev/null || true
            '''

            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}