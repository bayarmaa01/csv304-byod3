# ** CI/CD Using GitHub Actions & Jenkins**

## **📌 Overview – Understanding the Foundation of Modern Software Delivery**

Modern software delivery focuses on releasing software **faster**, **safer**, and with **higher quality**.
To achieve this, organizations use:

* **Automation tools** like Jenkins & GitHub Actions
* **Version control** like Git
* **Continuous Integration (CI)**
* **Continuous Delivery/Deployment (CD)**

The goal is simple:

> **Build, test, and deploy software automatically with minimum human effort.**

This approach reduces errors, speeds up releases, and ensures reliable deployments.

---

# **🔍 Understanding the Foundation of Modern Software Delivery**

Modern delivery practices use **DevOps principles** that bring together development and operations teams.

### ✔ Key Principles:

* **Automation** – automate builds, tests, deployments
* **Collaboration** – team-based workflow with Git & tools
* **Monitoring & Feedback** – measure everything
* **Infrastructure as Code** – reproducible systems
* **Continuous Improvement** – faster cycles

### ✔ Why Modern Delivery Matters:

* Faster software releases
* Higher product stability
* Reduced manual errors
* Better productivity
* Shorter feedback loops

---

# **⚙️ Stages of Continuous Integration & Continuous Delivery (CI/CD)**

CI/CD pipelines automate the software lifecycle.
Below are the core stages:

---

## **1️⃣ Source Stage**

* Developers write code and push to Git (GitHub).
* Triggers CI workflow.

---

## **2️⃣ Build Stage**

* Code is compiled or packaged.
* For Node.js → `npm install`, `npm build`.
* Ensures code can be successfully assembled.

---

## **3️⃣ Test Stage**

* Runs unit tests, integration tests, security scans.
* If any test fails → pipeline stops.
* Ensures code quality.

---

## **4️⃣ Artifact Packaging**

* Built files are packaged into

  * ZIP
  * Docker image
  * JAR/WAR
  * static files
* Artifacts stored for deployment.

---

## **5️⃣ Deployment Stage**

* Automatically deploy to

  * servers
  * cloud
  * GitHub Pages
  * Kubernetes
* Can require **manual approval**.

---

## **6️⃣ Monitoring & Feedback**

* Logs
* Notifications
* Test reports
* Build history

This ensures continuous improvement.

---

# **🚀 CI/CD with Jenkins**

Jenkins is an **open-source automation server** used widely in DevOps.

## **✔ Features**

* Freestyle jobs
* Pipelines (Scripted + Declarative)
* Plugins ecosystem
* Integration with Git, Docker, Maven

---

## **🔧 Jenkins CI/CD Workflow**

### **1. Jenkins Installation**

* Install via apt/yum
* Runs using systemd service

### **2. Global Tool Configuration**

Configure:

* JDK
* Maven
* Git

### **3. Freestyle Jobs**

* Pull code from GitHub
* Build and test
* Trigger automatically using webhook

### **4. Pipeline Jobs**

Pipeline defined in `Jenkinsfile`:

#### **Declarative Pipeline**

* Clean structure
* Build → Test → Deploy

#### **Scripted Pipeline**

* Fully Groovy-based
* Allows parallel execution

### **5. Multi-Branch Pipeline**

* Auto-detects GitHub branches
* Builds each branch separately

### **6. Shared Libraries**

Reusable functions across pipelines.

### **7. Credentials Management**

* Secure GitHub tokens
* SSH keys
* Docker Hub credentials

### **8. Docker Integration**

* Use Docker agents
* Build and push Docker images

---

# **🔁 CI/CD with GitHub Actions**

GitHub Actions provides **cloud-based CI/CD** inside your GitHub repository.

---

## **✔ Key Components**

### **1. Workflow**

YAML file stored in `.github/workflows/`

### **2. Jobs**

Define tasks to execute (build, test, deploy)

### **3. Steps**

Individual commands inside jobs

### **4. Runners**

Machines where jobs run

* Ubuntu
* Windows
* MacOS
* Self-hosted

### **5. Triggers**

* `push`
* `pull_request`
* `schedule` (CRON)
* `workflow_dispatch` (manual)

---

## **🔥 GitHub Actions Supports**

* Matrix builds
* Caching
* Artifacts upload/download
* Secrets
* Environment protection
* Pages deployment
* Docker Builds

All of these match your BYOD-3 practical tasks.

---

# **📦 Anatomy of a Continuous Delivery Pipeline**

A complete CD pipeline contains the following components:

---

## **1️⃣ Version Control Integration**

* GitHub/GitLab
* Branch protection rules
* Pull requests for collaboration

---

## **2️⃣ Automated Build**

* Code is packaged
* Dependencies installed
* Errors detected early

---

## **3️⃣ Continuous Testing**

* Unit tests
* Integration tests
* Security tests
* Performance checks

If tests fail → pipeline stops.

---

## **4️⃣ Artifact Management**

Generated output is stored securely:

* Docker image
* ZIP file
* JAR/WAR
* Build folder

Artifacts are used for deployment.

---

## **5️⃣ Continuous Deployment**

Automated deployment to:

* Production
* Staging
* GitHub Pages
* Cloud (AWS/Azure/GCP)

Deployments may require:

* Manual approval
* Protected environments

---

## **6️⃣ Monitoring & Notifications**

* Build logs
* Email/SMS/Slack alerts
* Test reports
* Dashboard to track builds

---

# **✔ Your Practical Tasks (Q1–Q20) Fit Into These Concepts**

* GitHub Actions → CI/CD automation
* Jenkins → Enterprise-grade CI/CD
* Matrix builds → multi-environment testing
* Secrets → secure delivery
* Docker → container-based delivery
* Artifact handling → build packaging
* Manual approvals → safe production deployment

---


