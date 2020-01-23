pipeline {
   agent any

   environment {
     // You must set the following environment variables
     ORGANIZATION_NAME = "gopac25"
     YOUR_DOCKERHUB_USERNAME = "gopac"

     SERVICE_NAME = "position-tracker"
     registry="${YOUR_DOCKERHUB_USERNAME}/${ORGANIZATION_NAME}-${SERVICE_NAME}:${BUILD_ID}"
     //registry = "gopac/gopac"
     registryCredential = 'dockerhub'
     dockerImage = ''
   }

   stages {
      stage('Preparation') {
         steps {
            cleanWs()
            git credentialsId: 'GitHub', url: "https://github.com/${ORGANIZATION_NAME}/${SERVICE_NAME}"
         }
      }
      stage('Build') {
         steps {
            sh '''mvn clean package'''
         }
      }
      stage('Code Analysis') {
         steps {
           mvn sonar:sonar -Dsonar.projectKey=javaspringboot \
           -Dsonar.host.url="http://192.168.145.146:9000" \
           -Dsonar.login=c428c0b436b92f1b9b629b5f597e60afead13a8a
         }
      }
      //stage('Build and Push Image') {
        // steps {
         // dockerImage = sh 'docker build -t ${REPOSITORY_TAG} .'
          //  dockerImage = docker.build registry + ":${REPOSITORY_TAG}"
     // }
      //}
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
      //stage('Deploy to Cluster') {
        //  steps {
          //          sh 'envsubst < ${WORKSPACE}/deploy.yaml | kubectl apply -f -'
          //}
      //}
      stage('Deploy to k8s'){
            steps{
                sshagent(['kops-machine']) {
                    sh 'envsubst < ${WORKSPACE}/deploy.yaml'
                    sh "scp -o StrictHostKeyChecking=no deploy.yaml ec2-user@13.235.114.100:/home/ec2-user/"
                    script{
                        try{
                            sh "ssh ec2-user@13.235.114.100 kubectl apply -f ."
                        }catch(error){
                            sh "ssh ec2-user@13.235.114.100 kubectl create -f ."
                        }
                    }
                }
            }
      }
   }
}
