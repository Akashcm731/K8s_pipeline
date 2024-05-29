pipeline {
	agent {label "new-node"}
	environment {
		Docker_Cred=credentials('docker_cred')
	}
	stages {
		stage ('SCM checkout') {
			steps {
				git branch:'main', url:'https://github.com/asifkhazi/Petclinic.git'
			}
		}
		stage('SonarQube Analysis Stage') {
                        steps{ 
                             sh '''mvn clean verify sonar:sonar \
                                  -Dsonar.projectKey=Petclinic \
                                  -Dsonar.projectName='Petclinic' \
                                  -Dsonar.host.url=http://18.61.160.246:9000 \
                                  -Dsonar.token=sqp_31b8a133b5206e9adbb167d7cfd6cdb456e07645'''
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
