pipeline {
  agent any
  environment {
    DISCORD_WEBHOOK = credentials('jenkins-discord-webhook')

  }
  stages {
    stage('Pre Setup') {
      steps {
        sh 'chmod +x gradlew'
      }
    }

    stage('Apply Patches') {
      steps {
        sh './gradlew applyPatches'
      }
    }

    stage('Build Server Jar') {
      steps {
        sh './gradlew createReobfPaperclipJar'
      }
    }

    stage('Test Server Jar') {
      steps {
        sh './gradlew test'
      }
    }

  }
  tools {
    jdk 'OpenJDK-18'
  }
  post {
    success {
      archiveArtifacts(artifacts: 'build/libs/**/sharkur-paperclip-*.jar', fingerprint: true)
    }
    always {
      discordSend(description: "**Build:** ${env.BUILD_ID}\n**Status:** ${currentBuild.currentResult}", link: env.BUILD_URL, result: currentBuild.currentResult, title: "Sharkur #${env.BUILD_ID}", webhookURL: "$DISCORD_WEBHOOK")
    }
  }
}
