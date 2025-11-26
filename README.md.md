# **## Q11. Jenkins Installation & Secure Setup**

## **🔹 Objective**

1. Install Jenkins on a Linux server using a package manager
2. Configure Jenkins as a systemd service
3. Implement RBAC (Role-Based Access Control) using the Role Strategy plugin
4. Assign different permissions to multiple users

---

## **🔹 1. Install Jenkins on Linux**

### **Step-by-Step Explanation**

Jenkins provides an official Debian/Ubuntu repository. Installing via package manager ensures:

* Automatic updates
* System-level service management
* Stable installation

### **Commands:**

```bash
sudo apt update
sudo apt install openjdk-11-jdk -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y
```

---

## **🔹 2. Run Jenkins as systemd Service**

When installed via package manager, Jenkins automatically creates a systemd service.

Start and enable:

```bash
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
```

**Why systemd?**

* Automatically starts at boot
* Monitoring & logging
* Restart on failure

---

## **🔹 3. Enable RBAC using Role Strategy Plugin**

### **Why RBAC?**

Jenkins by default has only admin/no-admin users.
Role Strategy Plugin adds:

* Fine-grained permissions
* Job-level, project-level, global-level access control

### **Steps**

1. Go to **Manage Jenkins → Manage Plugins → Available**
2. Search **Role Strategy Plugin** → Install
3. After installation:
   Go to **Manage Jenkins → Manage and Assign Roles**

---

### **4. Create & Assign Roles**

#### **Create Roles**

Go to: **Manage Roles**

Example roles:

| Role      | Permission            |
| --------- | --------------------- |
| developer | Build jobs, read jobs |
| manager   | Create/modify jobs    |
| viewer    | Read-only access      |

#### **Assign Users**

Go to: **Assign Roles**

Add:

* `user1` → developer
* `user2` → manager

---

---

# **## Q12. Global Tool Configuration with Validation**

## **🔹 Objective**

* Configure JDK, Maven, and Git globally
* Create a freestyle job to validate tools

---

## **🔹 Why Configure Tools Globally?**

Global tools:

* Ensure all jobs use consistent versions
* Avoid manual installation
* Jenkins automatically installs missing versions

---

## **🔹 Steps to Configure Tools**

Go to:
**Manage Jenkins → Global Tool Configuration**

### **1. Configure JDK**

Add:

* Name: `JDK11`
* Path or automatic installer

### **2. Configure Maven**

Add:

* Name: `Maven3`
* Select automatic installer

### **3. Configure Git**

Usually auto-detected. Add manually if needed.

---

## **🔹 Create Freestyle Job for Validation**

### **Build Script:**

```bash
echo "Validating JDK:"
java -version

echo "Validating Maven:"
mvn -version

echo "Validating Git:"
git --version
```

### **Explanation**

* Each command prints installed version
* Ensures tools are available in PATH
* Prevents runtime build failures

---

---

# **## Q13. Freestyle Job with Git + Webhook Trigger**

## **🔹 Objective**

* Pull code from private GitHub repo using SSH
* Trigger job automatically on push

---

## **🔹 1. Add SSH Credentials**

Go to:
**Credentials → Global → Add Credential**

Select:

* Type: **SSH Username with Private Key**
* Username: `git`
* Private key: Paste your SSH key

This allows Jenkins to authenticate with GitHub.

---

## **🔹 2. Configure Freestyle Job**

Under **Source Code Management → Git**:

* Repository URL:

```
git@github.com:<username>/<private-repo>.git
```

* Credentials: Select the SSH credential you added

---

## **🔹 3. Enable GitHub Webhook Trigger**

Under **Build Triggers**:
✔ Select **GitHub hook trigger for GITScm polling**

---

## **🔹 4. GitHub Webhook Setup**

Go to GitHub repo:
**Settings → Webhooks → Add Webhook**

Payload URL:

```
http://<jenkins-server>:8080/github-webhook/
```

Content type:

```
application/json
```

Event:
✔ Push Events

Now Jenkins automatically builds on every git push.

---

---

# **## Q14. Declarative Pipeline with Conditional Execution**

## **🔹 Objective**

* Create pipeline with Build, Test, Deploy
* Deploy stage only executes if Test succeeds
* Pipeline must use Jenkinsfile from repo

---

## **🔹 Jenkinsfile Explained**

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo "Building application..."
            }
        }

        stage('Test') {
            steps {
                echo "Running tests..."
            }
        }

        stage('Deploy') {
            when {
                succeeded()
            }
            steps {
                echo "Deploying application... (only if tests passed)"
            }
        }
    }
}
```

### **Explanation**

* `when { succeeded() }` ensures:
  ✔ Deploy runs only if all previous stages are successful

---

---

# **## Q15. Scripted Pipeline with Parallel Execution**

## **🔹 Objective**

* Execute Unit Tests and Integration Tests in parallel
* Archive test reports
* Notify if any tests fail

---

## **🔹 Scripted Pipeline**

```groovy
node {
    stage('Parallel Testing') {
        parallel(
            Unit_Tests: {
                echo "Running Unit Tests..."
                // run tests
            },
            Integration_Tests: {
                echo "Running Integration Tests..."
                // run tests
            }
        )
    }

    stage('Post Actions') {
        junit '**/test-results/*.xml'

        echo "Sending notification if tests failed..."
    }
}
```
node {

    stage('Checkout') {
        echo 'Checking out source code...'
        checkout scm
    }

    stage('Build') {
        echo 'Building the application...'
        sh 'mvn clean package -DskipTests'
    }

    stage('Parallel Tests') {
        parallel(
            "Unit Tests": {
                stage('Unit Tests') {
                    try {
                        echo 'Running unit tests...'
                        sh 'mvn test -Dtest=UnitTest'
                        junit '**/target/surefire-reports/*.xml'
                    } catch (err) {
                        echo "❌ Unit tests failed: ${err}"
                        currentBuild.result = 'FAILURE'
                        throw err
                    }
                }
            },

            "Integration Tests": {
                stage('Integration Tests') {
                    try {
                        echo 'Running integration tests...'
                        sh 'mvn verify -Dtest=IntegrationTest'
                        junit '**/target/failsafe-reports/*.xml'
                    } catch (err) {
                        echo "❌ Integration tests failed: ${err}"
                        currentBuild.result = 'FAILURE'
                        throw err
                    }
                }
            }
        )
    }

    stage('Post-build Actions') {
        echo 'Archiving reports...'
        archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
        junit allowEmptyResults: true, testResults: '**/target/*-reports/*.xml'
    }

    post {
        failure {
            echo 'Build failed! Sending email notification...'
            emailext(
                to: 'b.bayarmaa0321@gmail.com',
                subject: "❌ Jenkins Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    <p>Build <b>${env.JOB_NAME}</b> #${env.BUILD_NUMBER} has failed.</p>
                    <p>Check console output at: 
                    <a href='${env.BUILD_URL}'>${env.BUILD_URL}</a></p>
                """,
                attachLog: true
            )
        }

        success {
            echo '✅ Build succeeded!'
        }
    }
}

### **Explanation**

* `parallel{}` speeds up testing
* `junit` archiving shows test results in Jenkins UI
* Failures trigger built-in notifications

---

---

# **## Q16. Multi-Branch Pipeline with Branch Logic**

## **🔹 Objective**

* Automatically detect GitHub branches
* Build each branch independently
* Add branch-specific behavior

---

## **🔹 Jenkinsfile Example**

```groovy
pipeline {
    agent any

    stages {
        stage('Branch Logic') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        echo "Running Production Pipeline"
                    }
                    else if (env.BRANCH_NAME == 'develop') {
                        echo "Running Development Pipeline"
                    }
                    else if (env.BRANCH_NAME.startsWith('feature/')) {
                        echo "Running Feature Branch Pipeline"
                    }
                }
            }
        }
    }
}
```

### **Explanation**

* Jenkins automatically builds each branch
* Custom logic ensures different behaviors

---

---

# **## Q17. Shared Libraries in Pipelines**

## **🔹 Objective**

* Create reusable shared library
* Use library inside pipeline

---

## **🔹 Shared Library File Structure**

In Git repo:

```
(my-shared-lib)
 └─ vars/
       └─ pipelineInfo.groovy
```

---

## **pipelineInfo.groovy**

```groovy
def call() {
    echo "Build Number: ${env.BUILD_NUMBER}"
    echo "Current Branch: ${env.GIT_BRANCH}"
}
```

---

## **Use in Pipeline**

```groovy
@Library('my-shared-lib') _

pipeline {
    agent any

    stages {
        stage('Use Library') {
            steps {
                pipelineInfo()
            }
        }
    }
}
```

### **Explanation**

* Shared libraries promote code reuse
* Avoid duplicated logic

---

---

# **## Q18. Secure Credential Management**

## **🔹 Objective**

* Store GitHub credentials securely
* Use in pipeline for authentication

---

## **Using Username & Password/PAT**

```groovy
withCredentials([usernamePassword(credentialsId: 'github-creds',
                                  usernameVariable: 'USER',
                                  passwordVariable: 'PASS')]) {

    sh """
        git clone https://$USER:$PASS@github.com/user/private-repo.git
    """
}
```

### **Explanation**

* Credentials never appear in logs
* Jenkins injects them securely as environment variables

---

---

# **## Q19. Pipeline with Input Step and Timeout**

## **🔹 Objective**

* Pause pipeline for approval
* Abort if no response

---

## **Pipeline Example**

```groovy
pipeline {
    agent any

    stages {
        stage('Approval') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    input message: "Do you want to deploy?"
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "Deployment Approved."
            }
        }
    }
}
```

### **Explanation**

* `input` waits for manual approval
* `timeout` avoids stuck pipelines

---

---

# **## Q20. Docker Integration in Jenkins Pipeline**

## **🔹 Objective**

* Use Docker as agent
* Build Docker image
* Push to Docker Hub

---

## **1. Configure Jenkins for Docker**

Install Docker:

```bash
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

---

## **2. Pipeline**

```groovy
pipeline {
    agent any

    environment {
        DOCKER_CREDS = credentials('dockerhub-creds')
    }

    stages {
        stage('Build Image') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }

        stage('Push Image') {
            steps {
                sh """
                echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin
                docker tag myapp:latest mydockerhub/myapp:latest
                docker push mydockerhub/myapp:latest
                """
            }
        }
    }
}
```

### **Explanation**

* Jenkins logs in to Docker Hub securely
* Image is built and pushed automatically

---

---
