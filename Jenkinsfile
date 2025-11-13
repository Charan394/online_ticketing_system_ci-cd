pipeline {
    agent {
        label "slave"
    }

    environment {
       
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }

    stages {
        stage('Hello') {
            steps {
               git 'https://github.com/Charan394/online_ticketing_system_ci-cd.git'
            }
        }
        stage("building the image"){
            steps{
                sh 'docker build -t charan027/bookmyshow:1.0 .'
            }
        }
        stage("pushing the image and clean up"){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-cred', passwordVariable: 'psw', usernameVariable: 'user')]) {
                    sh """
                    echo "${psw}" | docker login -u ${user} --password-stdin
                    docker push ${user}/bookmyshow:1.0
                    docker image rm ${user}/bookmyshow:1.0
                    """
                }
            }
        }

        stage("Deploy to EKS") {
            steps {
                script {
                    echo "Configuring EKS Access..."
                    // 1. Authenticate with AWS to generate kubeconfig
                    //  the cluster name matches your actual AWS cluster name
                    sh "aws eks update-kubeconfig --name bookmyshow-cluster --region us-east-1"
                    
                    echo "Triggering Ansible Deployment..."
                    // 2. Run the Ansible Playbook
                    ansiblePlaybook(
                        playbook: 'deploy.yaml',
                        inventory: 'localhost,',  // It treats localhost as a list
                        colorized: true,
                        installation: 'ansible'  
                    )
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}