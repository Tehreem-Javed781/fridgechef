// FridgeChef - Part II containerized build pipeline
// Plugins used: Git, Pipeline, Docker Pipeline, Email Extension, GitHub
pipeline {
    agent any

    triggers {
        githubPush()          // run on every push (GitHub webhook)
    }

    environment {
        DB_PASSWORD = credentials('fridgechef-db-password')   // Jenkins "Secret text" credential
        SECRET_KEY  = credentials('fridgechef-secret-key')    // Jenkins "Secret text" credential
        COMPOSE     = 'docker compose -f docker-compose.jenkins.yml'
        APP_URL     = 'http://56.228.108.186:8081'                 // <-- change to your Elastic IP
    }

    options {
        timeout(time: 15, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages {
        stage('Checkout') {
            steps {
                // Git plugin: fetch the latest code from GitHub
                git branch: 'main', url: 'https://github.com/Tehreem-Javed781/fridgechef.git'
                script {
                    env.COMMIT_AUTHOR_EMAIL = sh(script: "git log -1 --pretty=format:'%ae'", returnStdout: true).trim()
                    env.COMMIT_MSG          = sh(script: "git log -1 --pretty=format:'%s'",  returnStdout: true).trim()
                }
                echo "Commit by ${env.COMMIT_AUTHOR_EMAIL}: ${env.COMMIT_MSG}"
            }
        }

        stage('Build & check in container') {
            steps {
                // Docker Pipeline plugin: run the build step inside a python container
                script {
                    docker.image('python:3.12-slim').inside('-e PYTHONDONTWRITEBYTECODE=1 -e HOME=/tmp') {
                        sh '''
                            python -m venv /tmp/venv
                            /tmp/venv/bin/pip install --no-cache-dir -q -r requirements.txt
                            /tmp/venv/bin/python -c "import application; print('application imports OK')"
                        '''
                    }
                }
            }
        }

        stage('Deploy with docker compose') {
            steps {
                sh '${COMPOSE} down --remove-orphans || true'
                sh '${COMPOSE} up -d'
            }
        }

        stage('Verify') {
            steps {
                // wait (max ~2.5 min) until the app answers and the database is connected
                sh '''
                    for i in $(seq 1 30); do
                        if curl -fs http://localhost:8081/health; then echo; echo "App is UP"; exit 0; fi
                        sleep 5
                    done
                    echo "App did not come up in time"; ${COMPOSE} logs --tail 50; exit 1
                '''
            }
        }
    }

    post {
        always {
            emailext(
                to: "${env.COMMIT_AUTHOR_EMAIL ?: ''}",
                recipientProviders: [developers(), requestor()],
                subject: "FridgeChef build #${env.BUILD_NUMBER}: ${currentBuild.currentResult}",
                mimeType: 'text/html',
                body: """
                    <h2>FridgeChef pipeline - ${currentBuild.currentResult}</h2>
                    <p><b>Job:</b> ${env.JOB_NAME} #${env.BUILD_NUMBER}</p>
                    <p><b>Commit:</b> ${env.COMMIT_MSG ?: 'n/a'} (by ${env.COMMIT_AUTHOR_EMAIL ?: 'n/a'})</p>
                    <p><b>Duration:</b> ${currentBuild.durationString}</p>
                    <p><b>Application:</b> <a href="${env.APP_URL}">${env.APP_URL}</a></p>
                    <p><b>Console log:</b> <a href="${env.BUILD_URL}console">${env.BUILD_URL}console</a></p>
                """,
                attachLog: true
            )
        }
    }
}
