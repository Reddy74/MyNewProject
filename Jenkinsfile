pipeline {  
 agent any  
 environment {  
  //dotnet = 'C:\\Program Files\\dotnet\\dotnet.exe'
  DATE = new Date().format('yy.M')
  TAG = "${BUILD_NUMBER}"
  AWS_ACCOUNT_ID="670166063118"
  AWS_DEFAULT_REGION="us-east-1"
  IMAGE_REPO_NAME="angularapp"
  IMAGE_TAG="${BUILD_NUMBER}"
  REPOSITORY_URI = "670166063118.dkr.ecr.us-east-1.amazonaws.com/angularapp"
  AWS_ECR_REGION = 'us-east-1'
  AWS_ECS_SERVICE = 'AngualAppService'
  AWS_ECS_TASK_DEFINITION = 'AngualAppTask'
  AWS_ECS_COMPATIBILITY = 'FARGATE'
  AWS_ECS_NETWORK_MODE = 'vpc-55c9682d'
  AWS_ECS_CPU = '256'
  AWS_ECS_MEMORY = '512'
  AWS_ECS_CLUSTER = 'AngualAppCluster'
  AWS_ECS_TASK_DEFINITION_PATH = 'container-definition-update-image.json'
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
        updateContainerDefinitionJsonWithImageVersion()
        sh("/usr/local/bin/aws ecs register-task-definition --region ${AWS_ECR_REGION} --family ${AWS_ECS_TASK_DEFINITION} --execution-role-arn ${AWS_ECS_EXECUTION_ROL} --requires-compatibilities ${AWS_ECS_COMPATIBILITY} --network-mode ${AWS_ECS_NETWORK_MODE} --cpu ${AWS_ECS_CPU} --memory ${AWS_ECS_MEMORY} --container-definitions file://${AWS_ECS_TASK_DEFINITION_PATH}")
        def taskRevision = sh(script: "/usr/local/bin/aws ecs describe-task-definition --task-definition ${AWS_ECS_TASK_DEFINITION} | egrep \"revision\" | tr \"/\" \" \" | awk '{print \$2}' | sed 's/\"\$//'", returnStdout: true)
        sh("/usr/local/bin/aws ecs update-service --cluster ${AWS_ECS_CLUSTER} --service ${AWS_ECS_SERVICE} --task-definition ${AWS_ECS_TASK_DEFINITION}:${taskRevision}")
      }
    }
  }
}
}
