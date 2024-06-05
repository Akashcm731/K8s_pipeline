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
				stash includes: '*.yaml', name: 'source'
			}
		}
		/*stage('SonarQube analysis') {
      			environment {
        			SCANNER_HOME = tool 'sonar-scanner'
      			}
      			steps {
        			withSonarQubeEnv('SonarQube Scanner') {
					sh 'mvn clean verify'
					sh '''${SCANNER_HOME}/bin/sonar-scanner \
                      				-Dsonar.projectKey=sonarqube-example \
  						-Dsonar.projectName='sonarqube-example' \
  						-Dsonar.host.url=http://18.61.81.218:9000 \
  						-Dsonar.token=sqp_f71a9634a9c08110611e0b17c404d423bb47bd41'''
        			}
     			 }
    		}*/
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
				sh 'kubectl apply -f Deployment.yaml Service.yaml'
			}
		}
		
	}
}
