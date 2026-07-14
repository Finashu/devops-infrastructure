pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', credentialsId: 'github-ssh-key', url: 'git@github.com:Finashu/devops-infrastructure.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'aws-credentials', 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'aws-credentials', 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    // Added environment variables to bypass the AWS metadata service check and stop the hanging behavior
                    withEnv([
                        'TF_LOG=DEBUG', 
                        'AWS_DEFAULT_REGION=us-east-1', 
                        'AWS_EC2_METADATA_DISABLED=true'
                    ]) {
                        sh 'terraform plan -input=false -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'aws-credentials', 
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    withEnv([
                        'AWS_DEFAULT_REGION=us-east-1', 
                        'AWS_EC2_METADATA_DISABLED=true'
                    ]) {
                        sh 'terraform apply -input=false -auto-approve tfplan'
                    }
                }
            }
        }
    }
}
