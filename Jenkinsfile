pipeline{
    agent{
        label "jenkins-agent"
    }
    tools {
        jdk 'Java17'
        maven 'Maven3'
    }
    environment {
        APP_NAME = "devops-prod-pipeline"
        RELEASE = "1.0.0"
        DOCKER_USER = "ebasangov"
        DOCKER_PASS = 'dockerhub'
        USERNAME = 'er'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
        JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
        JENKINS_URL = 'https://jenkins.dev.benae.xyz'
        JOB_TOKEN = 'gitops-token'

    }
    stages{
        stage("Cleanup Workspace"){
            steps {
                cleanWs()
            }

        }
    
        stage("Checkout from SCM"){
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/ebasangov/java_ci_cd'
            }

        }
        stage("Build application "){
            steps {
                sh "mvn clean package"
            }

        }
        stage("Test application"){
            steps {
                sh "mvn test"
            }

        }
        stage("Sonarqube Analysis") {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') {
                        sh "mvn sonar:sonar"
                    }
                }
            }

        }

        stage("Quality Gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }

        }

        stage("Build & Push Docker Image") {
            steps {
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }

                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }

        }

                stage("Trigger CD Pipline") {
            steps {
                script {
                    sh "curl -g -L --user ${USERNAME}:${JENKINS_API_TOKEN} --data 'IMAGE_TAG=${IMAGE_TAG}' '${JENKINS_URL}/job/gitops-pipeline/buildWithParameters?token=${JOB_TOKEN}'"
                }
            }

        }
    }    
}
