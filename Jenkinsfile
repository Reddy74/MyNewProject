pipeline {  
 agent any  
 environment {  
  //dotnet = 'C:\\Program Files\\dotnet\\dotnet.exe'
  DATE = new Date().format('yy.M')
  TAG = "${BUILD_NUMBER}"
  AWS_ACCOUNT_ID="670166063118"
  AWS_DEFAULT_REGION="us-east-1"
  IMAGE_REPO_NAME="mynewproject"
  IMAGE_TAG="${BUILD_NUMBER}"
  REPOSITORY_URI = "670166063118.dkr.ecr.us-east-1.amazonaws.com/mynewproject"
  AWS_ECR_REGION = 'us-east-1'
  AWS_ECS_SERVICE = 'mynewprojectService'
  AWS_ECS_TASK_DEFINITION = 'mynewprojectTask'
  AWS_ECS_COMPATIBILITY = 'FARGATE'
  AWS_ECS_NETWORK_MODE = 'awsvpc'
  AWS_ECS_CPU = '256'
  AWS_ECS_MEMORY = '512'
  AWS_ECS_CLUSTER = 'mynewprojectcluster'
  AWS_ECS_TASK_DEFINITION_PATH = 'container-definition-update-image.json'
  TASK_FAMILY = 'angularfamily'
   }  
 stages {  
 stage('Logging into AWS ECR') {
            steps {
                script {
                sh """aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"""
                //sh """aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 670166063118.dkr.ecr.us-east-1.amazonaws.com"""
                }
                 
            }
        }
  stage('Checkout') {  
   steps {
       git credentialsId: 'github-jenkins', url: 'https://github.com/Reddy74/MyNewProject', branch: 'main'
   }  
  } 
stage('Docker') {
    steps {    
     script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }   
            }
        }
  stage('Pushing to ECR') {
     steps{  
         script {
                sh """docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"""
                sh """docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"""
         }
        }
      }
   stage('Deploy in ECS') {
  steps {
      script {
        sh "aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${AWS_ECS_SERVICE} --force-new-deployment"
      }
    
    }
  }
}
}
