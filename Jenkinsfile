pipeline {
    agent any
    environment{
        dockerHome = tool 'myDocker'
        mavenHome = tool 'myMaven'
        PATH = "$dockerHome/bin:$mavenHome/bin:$PATH"
        DOCKER_REPO = 'jossy10/develops-project'
    }
    
    stages {
        
        stage('Compile & Packaging Project') {
            steps {
                // Run Maven on a Unix agent.
                // sh "mvn -Dmaven.test.failure.ignore=true clean package"
                sh 'mvn compile'
            }
        }
        stage('Build Docker Image'){
            steps{
                echo 'Building project docker image  ...'
                //sh 'docker build -t ${DOCKER_REPO}:0.0.${BUILD_NUMBER} .'
                script{
                    try{
                        dockerImage = docker.build("jossy10/develops-project:0.0.${env.BUILD_NUMBER}");
                    }catch (Exception e){
                        error "Docker build failed: ${e.message}"
                    }
                }
                sh 'docker images'
               
            }
        }
        stage('Push Docker Image'){
            steps{
                echo 'pushing image to docker hub coming in next build ...'
                sh 'docker push jossy10/develops-project:0.0.${BUILD_NUMBER}'     
            }
        }
        stage("Pulling Docker Image"){
            steps{
                echo 'pulling image from repo'
                sh 'sudo docker pull jossy10/develops-project:0.0.${BUILD_NUMBER}'
            }
        }
        stage("Deploying Docker Container"){
            steps{
                echo 'running docker container'
                sh 'sudo docker run -d --name devops-project -p 9090:4040 ${DOCKER_REPO}:0.0.${BUILD_NUMBER}'
            }
        }
    }
    post {
        success {
            echo 'Project completed successfully.'
        }
        failure{
            echo 'Docker image build or Push failed'
        }
    }
}
