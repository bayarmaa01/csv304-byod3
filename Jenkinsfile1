pipeline {
    agent any

    stages {
        stage('Main Branch Stage') {
            when { branch 'main' }
            steps {
                echo "Building MAIN branch"
            }
        }

        stage('Develop Branch Stage') {
            when { branch 'develop' }
            steps {
                echo "Building DEVELOP branch"
            }
        }

        stage('Feature Branch Stage') {
            when { branch pattern: "feature/.*", comparator: "REGEXP" }
            steps {
                echo "Building FEATURE branch"
            }
        }

        stage('Default Stage') {
            when {
                not {
                    anyOf {
                        branch 'main'
                        branch 'develop'
                        branch pattern: "feature/.*", comparator: "REGEXP"
                    }
                }
            }
            steps {
                echo "Running DEFAULT build logic for other branches"
            }
        }
    }
}
