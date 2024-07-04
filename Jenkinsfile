pipeline {
	agent any
	environment {
		Docker_Cred=credentials('DC')
	}
	stages {
		stage ('SCM checkout') {
			agent { label 'docker' }
			steps {
				git branch:'main', url:'https://github.com/Akashcm731/K8s_pipeline.git'
				stash(name: 'source', includes: '**/*.yaml')
			}
		}
		stage ('Build and Create docker image') {
            		agent { label 'docker' }
			steps {
				sh 'docker build -t ${Docker_Cred_USR}/tomcat:${BUILD_ID} -f Dockerfile .'
    				sh 'docker tag ${Docker_Cred_USR}/tomcat:${BUILD_ID} ${Docker_Cred_USR}/tomcat:latest'
			}
		}
		stage ('Push image to artifactory') {
             		agent { label 'docker' }
			steps {
				sh 'docker login -u ${Docker_Cred_USR} -p ${Docker_Cred_PSW}'
				sh 'docker push ${Docker_Cred_USR}/tomcat:${BUILD_ID}'
    				sh 'docker push ${Docker_Cred_USR}/tomcat:latest'
			}
		}
		stage ('Deploy') {
             		agent { label 'K8s' }
			steps {
				unstash 'source'
				sh 'microk8s kubectl apply -f Deployment.yaml -f Service.yaml'
			}
		}
		
	}
}
