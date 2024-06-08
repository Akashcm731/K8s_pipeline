pipeline {
	agent any
	environment {
		Docker_Cred=credentials('docker_cred')
	}
	stages {
		stage ('SCM checkout') {
			agent {
                		label 'new-node'
            		}
			steps {
				git branch:'main', url:'https://github.com/asifkhazi/sonarqube-example.git'
				stash(name: 'source', includes: '**/*.yaml')
			}
		}
		stage('SonarQube analysis') {
			agent {
                		label 'new-node'
            		}
      			environment {
        			SCANNER_HOME = tool 'sonar-scanner'
      			}
      			steps {
        			withSonarQubeEnv('SonarQubeServer') {
					sh 'mvn clean verify'
					sh '''${SCANNER_HOME}/bin/sonar-scanner \
                      				-Dsonar.projectKey=sonarqube-example \
  						-Dsonar.projectName=sonarqube-example'''
        			}
     			 }
    		}
		stage ('Build and Create docker image') {
            		agent {
                		label 'new-node'
            		}
			steps {
				sh 'docker build -t ${Docker_Cred_USR}/tomcatjar:v1.${BUILD_ID} -f Dockerfile .'
    				sh 'docker tag ${Docker_Cred_USR}/tomcatjar:v1.${BUILD_ID} ${Docker_Cred_USR}/tomcatjar:latest'
			}
		}
		stage ('Push image to artifactory') {
             		agent {
                		label 'new-node'
            		}
			steps {
				sh 'docker login -u ${Docker_Cred_USR} -p ${Docker_Cred_PSW}'
				sh 'docker push ${Docker_Cred_USR}/tomcatjar:v1.${BUILD_ID}'
    				sh 'docker push ${Docker_Cred_USR}/tomcatjar:latest'
			}
		}
		stage ('Deploy') {
             		agent {
                		label 'kubernetes'
            		}
			steps {
				unstash 'source'
				sh 'microk8s kubectl delete deploy tomcat-deploy'
				sh 'microk8s kubectl delete svc nodeport-svc'
				sh 'microk8s kubectl apply -f Deployment.yaml -f Service.yaml'
			}
		}
		
	}
}
