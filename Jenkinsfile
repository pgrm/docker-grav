#!groovy

if (env.BRANCH_NAME == 'master') {

node('static-website') {
	stage ('Checkout') {
		checkout scm
	}

	stage ('build and publish docker images') {
		sh 'chmod +x publish-dockerfiles.sh'
		docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-pgrm') {
			sh './publish-dockerfiles.sh'
		}
	}
}
	
}
