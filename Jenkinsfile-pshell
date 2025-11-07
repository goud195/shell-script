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
      steps {
        checkout scm
      }
    }
    stage('Run EC2 PowerShell script') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          powershell """
            # set env vars for AWS CLI
            \$env:AWS_ACCESS_KEY_ID='${AWS_ACCESS_KEY_ID}'
            \$env:AWS_SECRET_ACCESS_KEY='${AWS_SECRET_ACCESS_KEY}'
            \$env:AWS_DEFAULT_REGION='${AWS_REGION}'

            # go to workspace
            Set-Location '${env.WORKSPACE}'

            # run the PowerShell control script with the chosen action
            .\\ec2-control.ps1 ${params.ACTION}
          """
        }
      }
    }
  }
  post {
    always {
      echo "Pipeline finished (action=${params.ACTION})"
    }
  }
}
