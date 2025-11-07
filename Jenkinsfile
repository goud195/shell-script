pipeline {
  agent any 
  parameters {
    choice(name: 'ACTION', choices: ['start','stop','status'], description: 'Action to perform')
  }
  environment {
    AWS_REGION = 'us-east-1'
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Run EC2 script') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
            export AWS_DEFAULT_REGION=${AWS_REGION}
            chmod +x ./ec2-control.sh
            ./ec2-control.sh ${ACTION}
          '''
        }
      }
    }
  }

}
