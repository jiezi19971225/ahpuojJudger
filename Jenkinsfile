pipeline {
    agent any
    
    parameters {
        booleanParam(name: 'autoDeploy', defaultValue: true, description: '是否自动部署到服务器')
    }

    stages {
        stage('build'){
            steps {
              echo 'fetch source code'
              git 'https://gitee.com/jiezi19971225/ahpuojJudger'
              echo 'start build image'
              script{
                docker.withRegistry('https://ccr.ccs.tencentyun.com', 'dockerAccount') {
                  def customImage = docker.build("ccr.ccs.tencentyun.com/jiezi19971225/ahpuoj-judger")
                  customImage.push()
                  customImage.push("v${env.BUILD_NUMBER}")
                }
              }
            }
        }
        stage('deploy'){
          when {
            expression { params.autoDeploy == true }
          }
          steps {
            echo 'start deploy to school oj server'
            sshPublisher(publishers: [sshPublisherDesc(
              configName: 'schoolOJ', 
              transfers: [sshTransfer(
                cleanRemote: false, 
                excludes: '', 
                execCommand: '''
echo "开始构建后操作"
cd /home/ahpuoj/ahpuojDocker/compose
cat > docker-compose.tmp.yml<<EOF
version: "3.2"
services:
  judger:
    image: ccr.ccs.tencentyun.com/jiezi19971225/ahpuoj-judger:v${BUILD_NUMBER}
    container_name: ahpuojv2_judger
    restart: always
    tty: true
    volumes:
      - ./scheduler_config.ini:/home/judge/scheduler/config.ini:ro
      - oj-problemdata-volume:/home/judge/hustoj_core/data:ro
    depends_on:
      - db
      - db-slave
      - redis
      - rabbitmq
    privileged: true
EOF
docker-compose -f docker-compose.yml -f docker-compose.tmp.yml pull judger
docker-compose -f docker-compose.yml -f docker-compose.tmp.yml up -d judger
docker image prune -f --filter "dangling=true"
                ''', 
                execTimeout: 120000,
                flatten: false, 
                makeEmptyDirs: false, 
                noDefaultExcludes: false, 
                patternSeparator: '[, ]+', 
                remoteDirectory: '/home/ahpuoj/ahpuojDocker/compose', 
                remoteDirectorySDF: false, 
                removePrefix: '', 
                sourceFiles: '')], 
              usePromotionTimestamp: false, 
              useWorkspaceInPromotion: false, 
              verbose: false)])
          }
        }
    }
    post {
        always {
            echo '🎉 done!!! 🎉'
        }
    }
}