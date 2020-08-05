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
    }
}
