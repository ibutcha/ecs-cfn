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
}
