#!groovy
node {
    def git
    def commitHash
    def buildImage

    stage("ssh-agent") {
        script {
            sshagent(credentials:['94bb4d82-768b-49ba-86c5-5a6673b7868d']) {
                sh 'ssh -o StrictHostKeyChecking=no -l kubemaster 192.168.0.160 uname -a'
            }
        }
    }

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

    stage('Kubernetes Deploy') {
        sh 'kubectl -n=development apply -f deployment.yaml'
    }
}
