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
      stage('Container Scanning') {
         parallel {
            stage('Run Anchore') {
               steps {
                  pwsh(script: """
                     Write-Output "blackdentech/jenkins-course" > anchore_images
                  """)
                  anchore bailOnFail: false, bailOnPluginFail: false, name: 'anchore_images'
               }
            }
            stage('Run Trivy') {
               steps {
                  sleep(time: 30, unit: 'SECONDS')
                  // pwsh(script: """
                  // C:\\Windows\\System32\\wsl.exe -- sudo trivy blackdentech/jenkins-course
                  // """)
               }
            }
         }
      }
      stage('Deploy to QA') {
         steps {
            acsDeploy(
               azureCredentialsId: 'azure-jenkins-app',
               configFilePaths: '**/*.yaml',
               containerService: 'qa-demo-cluster | AKS',
               resourceGroupName: 'qa-demo',
               sshCredentialsId: ''
            )
         }
      }
      // stage('Approve PROD Deploy') {
      //    options {
      //       timeout(time: 1, unit: 'HOURS') 
      //    }
      //    steps {
      //       input {
      //          message: "Deploy?"
      //          ok: "By your command..."
      //       }
      //    }
      // }
      stage('Deploy to PROD') {
         steps {
            // TODO
            echo 'Add aks deploy step'
         }
      }
   }
}
