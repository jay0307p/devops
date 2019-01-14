#!groovy
def call() {
node {
//label 'jenkins-master'

    def server
    def buildInfo
    def rtMaven
    //def pom = readMavenPom file: 'pom.xml'
    //version: "${pom.version}"
    //def pom = readMavenPom file: 'pom.xml'
    //echo "{pom}"
    //sh 'sudo service docker start'
    stage ('scm Checkout') {
    
        git credentialsId: '1', url: 'https://jay0307p@bitbucket.org/jay0307p/devops.git'
    }
    
    def pom = readMavenPom file: 'pom.xml'
    version = "${pom.version}"
    
    stage ('Artifactory & Maven configuration') {
        // Obtain an Artifactory server instance, defined in Jenkins --> Manage:
        server = Artifactory.server "Artifactory"

        rtMaven = Artifactory.newMavenBuild()
        rtMaven.tool = "Maven" // Tool name from Jenkins configuration
        rtMaven.deployer releaseRepo: 'Jenkins-integration', snapshotRepo: 'Jenkins-snapshot', server: server
        rtMaven.resolver releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot', server: server
        rtMaven.deployer.deployArtifacts = false // Disable artifacts deployment during Maven run

        buildInfo = Artifactory.newBuildInfo()
    }
	
 	stage('SonarQube analysis') {
        def scannerHome = tool 'sonarqube';
		withSonarQubeEnv('sonarqube') {
		  // requires SonarQube Scanner for Maven 3.2+
		  rtMaven.run pom: 'pom.xml', goals: "sonar:sonar -e -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.login=${env.SONAR_AUTH_TOKEN} -Dsonar.projectKey=${env.JOB_BASE_NAME} -Dsonar.sources=src -Dsonar.projectBaseDir=${pwd()}".toString()
		}
	}
/*	
	stage("Quality Gate"){
          timeout(time: 1, unit: 'MINUTES') {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
                error "Pipeline aborted due to quality gate failure: ${qg.status}"
            }
        }
    }
*/    
	stage('Mvn Package'){
     //def mvnHome = tool name: 'Maven', type: 'maven'
     //def mvnCMD = "${mvnHome}/bin/mvn"
     //sh "${mvnCMD} clean package -DskipTests=true"
     
     echo "${version}"
	 rtMaven.run pom: 'pom.xml', goals: 'clean package', buildInfo: buildInfo
    }
		
	/*stage ('Test') {
        rtMaven.run pom: 'pom.xml', goals: 'clean test'
    }
        
    stage ('Install') {
        rtMaven.run pom: 'pom.xml', goals: 'install', buildInfo: buildInfo
    }
 }*/
    stage ('Deploy') {
        input 'Do you want to deploy to Artifactory?'
        rtMaven.deployer.deployArtifacts buildInfo
    }
        
    stage ('Publish build info') {
        server.publishBuildInfo buildInfo
    }
	def Image
	stage('Build Docker Image'){
     //sh 'sudo docker build -t jay0307p/test:${JOB_BASE_NAME}-${BUILD_NUMBER} .'
     //sh 'sudo chown -R jenkins:jenkins /var/run/docker /var/run/docker.sock'
     def dockerfile = 'Dockerfile.test'
     Image = docker.build("jay0307p/${JOB_BASE_NAME}:${env.BUILD_ID}", "-f ${dockerfile} .")
     //env.Image = Image
   }
   stage('Push Docker Image'){
     //withCredentials([string(credentialsId: 'dockerhubpswd', variable: 'dockerhubpswd')]) {
      //  sh "sudo docker login -u jay0307p -p ${dockerhubpswd}"
		//}
     //sh 'sudo docker push jay0307p/test:${JOB_BASE_NAME}-${BUILD_NUMBER}'
   //}
   docker.withRegistry('', 'dockerhub-login') {
   Image.push()
   //Image.push('latest')
   }
  }
 
}
}
