pipeline {
  agent any
  parameters {
    choice(name: 'ACTION', choices: ['start','stop','status'], description: 'Action to perform')
    choice(name: 'ENVIRONMENT', choices: ['DEV','TEST','PROD'], description: 'Target environment')
  }
  environment {
    AWS_REGION = 'us-east-1'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Run EC2 script') {
      steps {
        script {
          // Determine which credentials to use based on environment
          def accessKeyIdCred = "AWS_ACCESS_KEY_ID_${params.ENVIRONMENT}"
          def secretKeyCred   = "AWS_SECRET_ACCESS_KEY_${params.ENVIRONMENT}"

          echo "Using credentials for environment: ${params.ENVIRONMENT}"

          withCredentials([
            string(credentialsId: accessKeyIdCred, variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: secretKeyCred, variable: 'AWS_SECRET_ACCESS_KEY')
          ]) {
            sh """
              set -e
              export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
              export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
              export AWS_DEFAULT_REGION=${AWS_REGION}

              chmod +x ./ec2-control.sh
              ./ec2-control.sh ${ACTION} ${ENVIRONMENT}
            """
          }
        }
      }
    }
  }

  post {
    always {
      echo "Completed: ${params.ACTION} on ${params.ENVIRONMENT}"
    }
  }
}
