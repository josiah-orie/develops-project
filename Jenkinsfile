pipeline {
    agent any
    environment{
        dockerHome = tool 'myDocker'
        mavenHome = tool 'myMaven'
        PATH = "$dockerHome/bin:$mavenHome/bin:$PATH"
        DOCKER_REPO = 'jossy10/develops-project'
    }
    
    stages {
        
        stage('Compiling Project') {
            steps {
                // Run Maven on a Unix agent.
                // sh "mvn -Dmaven.test.failure.ignore=true clean package"
                sh 'mvn compile'
            }
        }
        stage('Packaging & Build Docker Image'){
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
                script{
                    // This step should not normally be used in your script. Consult the inline help for details.
                    withDockerRegistry(credentialsId: '5e1d87df-37f3-43fb-9856-44d0916453bf', toolName: 'myDocker') {
                        sh 'docker push jossy10/develops-project:0.0.${BUILD_NUMBER}'
                    }
                }
            }
        }
        stage("Pulling Docker Image"){
            steps{
                echo 'pulling image from repo'
                sh 'docker pull jossy10/develops-project:0.0.${BUILD_NUMBER}'
            }
        }
        stage("Deploying Docker Container"){
            steps{
                echo 'running docker container'
                sh 'docker run -d --name devops-project -p 9090:4040 ${DOCKER_REPO}:0.0.${BUILD_NUMBER}'
            }
        }
    }
    post {
        success {
            echo 'Pipeline executed successfully.'
        }
        failure{
            echo 'Docker image build or Push failed'
        }
    }
}
