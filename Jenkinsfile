pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = 'true'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Tools') {
            steps {
                sh 'terraform version'
                sh 'aws --version'
                sh 'git --version'
            }
        }

        stage('AWS Authentication') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-cred'
                ]]) {
                    sh 'aws sts get-caller-identity'
                }
            }
        }

        stage('Terraform Init') {
    steps {
        withCredentials([
            string(
                credentialsId: 'hcp-terraform-token',
                variable: 'TF_TOKEN_app_terraform_io'
            ),
            [
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: 'aws-cred'
            ]
        ]) {
            sh '''
                rm -f terraform.tfstate terraform.tfstate.backup
                terraform init -input=false
            '''
        }
    }
}

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
    steps {
        withCredentials([
            string(
                credentialsId: 'hcp-terraform-token',
                variable: 'TF_TOKEN_app_terraform_io'
            ),
            [
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: 'aws-cred'
            ]
        ]) {
            sh 'terraform plan -input=false -no-color'
        }
    }
}

        stage('Terraform Approval') {
    steps {
        input(
            message: 'Terraform plan reviewed. Do you want to apply the infrastructure?',
            ok: 'Apply'
        )
    }
}

stage('Terraform Apply') {
    steps {
        withCredentials([
            string(
                credentialsId: 'hcp-terraform-token',
                variable: 'TF_TOKEN_app_terraform_io'
            ),
            [
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: 'aws-cred'
            ]
        ]) {
            sh 'terraform apply -input=false -auto-approve'
        }
    }
}
    }
}