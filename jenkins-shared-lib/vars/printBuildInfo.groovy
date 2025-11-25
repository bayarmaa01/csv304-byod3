def call() {
    echo "===== Shared Library Output ====="
    echo "Current Build Number: ${env.BUILD_NUMBER}"
    echo "Current Git Branch: ${env.GIT_BRANCH}"
    echo "================================="
}
