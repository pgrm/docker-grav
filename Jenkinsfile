#!groovy

slackChannel = '#webbsc'
slackDomain = 'grman-it'
slackToken = '1jPN1qnmKt533kg3SSc3xWsY'
tag = "office-redirect-${env.BRANCH_NAME}"

node('static-website') {
	try {
		notifyBuild('STARTED')
		stage ('Checkout') {
			checkout scm
		}

		stage ('build and publish docker images') {
      sh 'chmod +x publish-dockerfiles.sh'
      sh './publish-dockerfiles.sh'
		}
	}
	catch (e) {
		currentBuild.result = 'FAILED'
		throw e
	}
	finally {
		notifyBuild(currentBuild.result)
	}
}

def notifyBuild(String buildStatus = 'STARTED') {
  buildStatus =  buildStatus ?: 'SUCCESS'

  def colorCode = '#FF0000'
  def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
  def summary = "${subject} (${env.BUILD_URL})"

  // Override default values based on build status
  if (buildStatus == 'STARTED') {
    colorCode = '#FFFF00'
  } else if (buildStatus == 'SUCCESS') {
    colorCode = '#00FF00'
  } else {
    colorCode = '#FF0000'
  }

  slackSend (color: colorCode, message: summary, channel: slackChannel, teamDomain: slackDomain, token: slackToken)
}
