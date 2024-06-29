pipeline {
	agent any
	environment {
		Docker_Cred=credentials('docker_cred')
	}
	stages {
		stage ('SCM checkout') {
			agent {
                		label 'docker-env'
            		}
			steps {
				git branch:'main', url:'https://github.com/asifkhazi/sonarqube-example.git'
				stash(name: 'source', includes: '**/*.yaml')
			}
		}
		stage ('Build and Create docker image') {
            		agent {
                		label 'docker-env'
            		}
			steps {
				sh 'docker build -t ${Docker_Cred_USR}/tomcat:v1.${BUILD_ID} -f Dockerfile .'
    				sh 'docker tag ${Docker_Cred_USR}/tomcat:v1.${BUILD_ID} ${Docker_Cred_USR}/tomcat:latest'
			}
		}
		stage ('Push image to artifactory') {
             		agent {
                		label 'docker-env'
            		}
			steps {
				sh 'docker login -u ${Docker_Cred_USR} -p ${Docker_Cred_PSW}'
				sh 'docker push ${Docker_Cred_USR}/tomcat:v1.${BUILD_ID}'
    				sh 'docker push ${Docker_Cred_USR}/tomcat:latest'
			}
		}
		stage ('Deploy') {
             		agent {
                		label 'kubernetes'
            		}
			steps {
				unstash 'source'
				sh 'microk8s kubectl apply -f Deployment.yaml -f Service.yaml'
			}
		}
		
	}
}
