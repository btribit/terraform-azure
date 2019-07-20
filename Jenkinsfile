pipeline {
  agent {
    kubernetes {
      label 'kaniko'
      yaml """
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /root/.docker
      - name: kaniko-cache
        mountPath: /cache
  volumes:
  - name: kaniko-cache
    persistentVolumeClaim:
      claimName: kaniko-cache
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: regcred
          items:
            - key: config.json
              path: config.json
"""
    }
  }
  stages {
    stage('Build with Kaniko') {
      environment {
        PATH = "/busybox:/kaniko:$PATH"
      }
      steps {
        checkout scm
        container(name: 'kaniko', shell: '/busybox/sh') {
            sh '''#!/busybox/sh
            find .
            export VERSION=1.0.${BUILD_NUMBER}
            set
            /kaniko/executor --context=dir://${WORKSPACE} --dockerfile=Dockerfile --cache=true \
              --destination=tribitio/terraform-azure:${VERSION} \
              --destination=tribitio/terraform-azure:latest
            '''
        }
      }
    }
  }
}
