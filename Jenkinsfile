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
      //}}
   }
}
