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
        sh 'chmod +x gradlew'
        sh './gradlew check'
    }

    stage('Build') {
        sh './gradlew build -x test'
    }

    stage('Build Docker Image') {
        buildImage = docker.build("nexclipper/jekins-pipeline-test-app:${commitHash}")
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

    // stage('Kubernetes Deploy') {
    //     sh 'kubectl -n=development apply -f deployment.yaml'
    // }
}
