pipeline {
	agent {label "new-node"}
	environment {
		Docker_Cred=credentials('docker_cred')
	}
	stages {
		stage ('SCM checkout') {
			steps {
				git branch:'main', url:'https://github.com/asifkhazi/sonarqube-example.git'
			}
		}
		stage('SonarQube Analysis Stage') {
                        steps{ 
                            sh '''mvn clean verify sonar:sonar \
  					-Dsonar.projectKey=sonarqube-example \
  					-Dsonar.projectName='sonarqube-example' \
 					-Dsonar.host.url=http://18.61.158.157:9000 \
  					-Dsonar.token=sqp_f7d827a705cd0ce11b42d32bd64dea4437528176'''
			}
        	}
		stage ('Build and Create docker image') {
			steps {
				sh 'docker build -t ${Docker_Cred_USR}/tomcatjar:${BUILD_ID} -f Dockerfile .'
			}
		}
		stage ('Push image to artifactory') {
			steps {
				sh 'docker login -u ${Docker_Cred_USR} -p ${Docker_Cred_PSW}'
				sh 'docker push ${Docker_Cred_USR}/tomcatjar:${BUILD_ID}'
			}
		}
		stage ('Deploy') {
			steps {
				sh 'docker run --name cont-${BUILD_ID} ${Docker_Cred_USR}/tomcatjar:${BUILD_ID}'
			}
		}
		
	}
}
