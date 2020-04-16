pipeline {
   agent any

   stages {
      stage('Verify Branch') {
         steps {
            echo "$GIT_BRANCH"
         }
      }
      stage('Docker Build') {
         steps {
            pwsh(script: 'docker images -a')
            pwsh(script: """
               cd azure-vote/
               docker images -a
               docker build -t jenkins-pipeline .
               docker images -a
               cd ..
            """)
         }
      }
      stage('Start test app') {
         steps {
            pwsh(script: """
               docker-compose up -d
               ./scripts/test_container.ps1
            """)
         }
         post {
            success {
               echo "App started successfully :)"
            }
            failure {
               echo "App failed to start :("
            }
         }
      }
      stage('Run Tests') {
         steps {
            pwsh(script: """
               pytest ./tests/test_sample.py
            """)
         }
      }
      stage('Stop test app') {
         steps {
            pwsh(script: """
               docker-compose down
            """)
         }
      }
      stage('Run Trivy') {
         agent {
            docker {
               image 'golang:1.14.2'
            }
         }
         steps {
            sh(script: """
               mkdir -p \$GOPATH/src/github.com/aquasecurity
               cd \$GOPATH/src/github.com/aquasecurity
               git clone https://github.com/aquasecurity/trivy
               cd trivy/cmd/trivy/
               export GO111MODULE=on
               go install
               trivy blackdentech/jenkins-course
            """)
         }
      }
   }
}
