node("ecs") {
    stage("Checkout") {
        checkout([
            $class                             : 'GitSCM'
            , branches                         : [[name: "origin/$GIT_BRANCH"]]
            , doGenerateSubmoduleConfigurations: false
            , extensions                       : []
            , submoduleCfg                     : []
            , userRemoteConfigs                : [[
                    url: "git@github.com:ibutcha/ecs-cfn.git",
                    credentialsId: "github-butch"
            ]]
        ])
    }

    stage("AssumeRole") {
        def awsCred = readJSON text: sh (
            script: "aws sts assume-role --role-arn $AWS_JOB_ROLE --role-session-name jenkins-worker-role --duration-seconds 900",
            returnStdout: true
        ).trim()
        env.AWS_ACCESS_KEY_ID = awsCred.Credentials.AccessKeyId
        env.AWS_SECRET_ACCESS_KEY = awsCred.Credentials.SecretAccessKey
        env.AWS_SESSION_TOKEN = awsCred.Credentials.SessionToken
        env.AWS_DEFAULT_REGION = AWS_REGION
        sh 'aws sts get-caller-identity'
    }

    stage("Provision VPCs & SubNets") {
        sh 'bash cfn.sh ecs-vpc ./vpc/core-infrastructure.yaml'
    }

    stage("Provision ECS EC2 Cluster") {
        sh 'bash cfn.sh ecs-ec2 ./ecs/ec2/cluster.yaml'
    }

    stage("Create ECR Repositories") {
        sh 'bash cfn.sh ecs-repositories ./ecr/repositories.yaml'
    }

    stage("Create/Update Ecs Execution Role") {
        sh 'bash cfn.sh ecs-taskExecutionRole ./iam/ecs/task-execution-role.yaml CAPABILITY_NAMED_IAM'
    }

}
