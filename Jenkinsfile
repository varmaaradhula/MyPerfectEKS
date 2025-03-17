pipeline{
    agent any
    environment {
        GIT_REPO_URL = 'https://github.com/varmaaradhula/MyPerfectEKS.git'
        GIT_BRANCH = 'master'
        S3_BUCKET = 'barista-infra-state-bucket'
        TF_PATH = 'terraform'
        S3_KEY = 'terraform/state.tfstate'
        AWS_REGION = 'eu-west-2'
        CLUSTER_NAME = "barista-eks-cluster"
       // AWS_CREDENTIALS = credentials('awscreds')
        TERRAFORM_APPLY_STATUS = 'false'
        GET_KUBECONFIG_STATUS = 'false'
    }

    stages{

        stage('Checkout code from Git Repo'){

            steps{
                echo "Checking out terraform repo from GitHub"

                git branch: "${GIT_BRANCH}", url: "${GIT_REPO_URL}"
            }
        }

        stage('Config AWS credentials'){
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding', 
                     credentialsId: 'awscreds'] // Replace with your Jenkins credential ID
                ]) {
                    script {
                        // AWS credentials will be available as environment variables
                        sh '''
                        echo "Configuring AWS CLI"
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set default.region ${AWS_REGION}
                        '''
                    }
                }
            }
        }

        stage('Intiate Terraform'){
            steps {
                echo 'Intiating Terraform'
                dir("${TF_PATH}"){

                    script{
                        sh '''
                        terraform init \
                          -backend-config="bucket=${S3_BUCKET}" \
                          -backend-config="key=terraform/state.tfstate" \
                          -backend-config="region=${AWS_REGION}"
                          '''
                    }
                }
            }
        }
        stage('Terraform Validate') {
            steps {
                echo 'Validating Terraform configuration...'
                dir("${TF_PATH}"){
                    script{
                sh 'terraform validate'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo 'Planning Terraform and getting output file'
                dir("${TF_PATH}"){
                    script{
                        sh '''
                        terraform plan \
                          -out=tfplan.out
                        '''
                    }
                }
                    }
                }

        stage('Terraform Apply') {
            steps {
                echo ' Applying terraform plan'
                dir("${TF_PATH}"){
                    script{
                sh 'terraform apply tfplan.out'
                    }
                }
            }
            post {
                success {
                    script {
                        // Set a shared variable to indicate success
                        currentBuild.description = 'Terraform Apply Success'
                        currentBuild.displayName = "Terraform Applied"
                        //env.TERRAFORM_APPLY_STATUS = 'true'
                        //writeFile file: 'terraform_success.txt', text: 'true'
        }
                }
            }
        }

        stage('Retrieve Kubeconfig') {
            when {
                expression {
                    // Execute only if Terraform Apply was successful
                    //return env.TERRAFORM_APPLY_STATUS == 'true'
                    //return fileExists('terraform_success.txt')
                    return currentBuild.description?.contains('Terraform Apply Success')
                }
            }
            steps {
                sh '''
                # Example for AWS EKS
                aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}
                '''
            }
        }

        
        }
}