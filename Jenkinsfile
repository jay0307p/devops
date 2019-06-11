pipeline {
    agent any
    stages {
        stage('Test Variables') {
          steps {
              
            sh 'echo ${GIT_BRANCH}'
            sh 'echo ${BRANCH_NAME}'
            sh 'echo ${JOB_BASE_NAME}'
            sh 'echo ${COMPRESSEDBUILD}'
            sh 'echo ${JOB_BASE_NAME}'
              
          	}
        }
        stage('Deploy') {
            steps {
                script {
                    
                    sh 'echo ---- Attempting to deploy application to ${GIT_BRANCH} environment servers. ----'
                    sh 'echo ---- Current branch being deployed: ${GIT_BRANCH} ----'
                    sh 'chmod +x deploy.sh'
                    sh 'chown -R jenkins:jenkins deploy.sh'
                    sh './deploy.sh'
                    
                }
            }
        }
    }
}
