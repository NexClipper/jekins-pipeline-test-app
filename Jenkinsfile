#!groovy
node {
    def git
    def commitHash
    def buildImage

    stage('Checkout') {
        git = checkout scm
        commitHash = git.GIT_COMMIT
    }

    stage('Test') {
        sh './gradlew check'
    }

    stage('Build') {
        sh './gradlew build -x test'
    }

    stage('Build Docker Image') {
        buildImage = docker.build("ssipflow/sample-demo:${commitHash}")
    }

    stage('Archive') {
        parallel (
                "Archive Artifacts" : {
                    archiveArtifacts artifacts: '**/build/libs/*.jar', fingerprint: true
                },
                "Docker Image Push" : {
                    buildImage.push("${commitHash}")
                    buildImage.push("latest")
                }
        )
    }

    stage('Kubernetes Deploy') {
        sh 'kubectl -n=development apply -f deployment.yaml'
    }
}