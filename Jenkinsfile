#!groovy
node {
    def git
    def commitHash
    def buildImage

    // stage("ssh-agent") {
    //     script {
    //         sshagent(credentials:['7305cd8e-2078-4f53-a205-ff05567f500a']) {
    //             sh 'ssh -o StrictHostKeyChecking=no -l root 192.168.0.171 uname -a'
    //         }
    //     }
    // }

    stage('Checkout') {
        git = checkout scm
        //commitHash = git.GIT_COMMIT
        commitHash = git.GIT_BRANCH
        sh 'chmod +x gradlew'
    }

    if(commitHash == 'v-0.1') {
        stage('Test') {
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

        stage('Kubernetes Deploy') {
            script {
                sshagent(credentials:['7305cd8e-2078-4f53-a205-ff05567f500a']) {
                    sh 'ssh -o StrictHostKeyChecking=no -l root 192.168.0.171 kubectl --namespace=developer-mg apply -f /root/devloper-mg/jenkins-pipeline-test-app.yaml'
                }
            }
        }
    }
}
