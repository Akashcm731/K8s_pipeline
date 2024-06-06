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
        			withSonarQubeEnv('SonarQube Scanner') {
					sh 'mvn clean verify'
					sh '''${SCANNER_HOME}/bin/sonar-scanner \
                      				-Dsonar.projectKey=sonarqube-example \
  						-Dsonar.projectName='sonarqube-example' \
  						-Dsonar.host.url=http://18.60.53.214:9000 \
  						-Dsonar.token=sqp_0d50267cdaa1c16759bb40c0f255947615a0a786'''
        			}
     			 }
    		}
		stage ('Build and Create docker image') {
            		agent {
                		label 'new-node'
            		}
			steps {
				sh 'docker build -t ${Docker_Cred_USR}/tomcatjar:${BUILD_ID} -f Dockerfile .'
			}
		}
		stage ('Push image to artifactory') {
             		agent {
                		label 'new-node'
            		}
			steps {
				sh 'docker login -u ${Docker_Cred_USR} -p ${Docker_Cred_PSW}'
				sh 'docker push ${Docker_Cred_USR}/tomcatjar:${BUILD_ID}'
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
