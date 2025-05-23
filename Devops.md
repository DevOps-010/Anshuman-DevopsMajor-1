# DevSecOps: OpenAI Chatbot UI Deployment in EKS with Jenkins and Terraform

![text](https://imgur.com/MdxoqmL.png)

## **Introduction:**

In today’s digital world, user engagement is key to the success of any application. Implementing DevSecOps practices is essential for ensuring security, reliability, and efficient deployment processes. In this project, we aim to implement DevSecOps for deploying an OpenAI Chatbot UI. We will use Kubernetes (EKS) for container orchestration, Jenkins for Continuous Integration/Continuous Deployment (CI/CD), and Docker for containerization.

**What is ChatBOT?**

ChatBOT is an AI-powered conversational agent trained on extensive human conversation data. It utilizes natural language processing techniques to understand user queries and provide human-like responses. By simulating natural language interactions, ChatBOT enhances user engagement and provides personalized assistance to users.

**Why ChatBOT?**

**1\. Personalized Interactions:** ChatBOT enables personalized interactions by understanding user queries and responding in a conversational manner, fostering engagement and satisfaction.  
  
**2\. 24/7 Availability:** Unlike human agents, ChatBOT is available 24/7, ensuring instant responses to user queries and delivering a seamless user experience round the clock.  
  
**3\. Scalability:** With ChatBOT deployed in our application, we can efficiently handle a large volume of user interactions, ensuring scalability as our user base expands.

**How We’re Deploying ChatBOT?**

**1\. Containerization with Docker:** We’re containerizing the ChatBOT application using Docker, which provides lightweight, portable, and isolated environments for running applications. Docker enables consistent deployment across different environments, simplifying the deployment process and ensuring consistency.

**2\. Orchestration with Kubernetes (EKS):** Kubernetes provides powerful orchestration capabilities for managing containerized applications at scale. We’re leveraging Amazon Elastic Kubernetes Service (EKS) to deploy and manage our Docker containers efficiently. EKS automates container deployment, scaling, and management, ensuring high availability and resilience.

**3\. CI/CD with Jenkins:** Jenkins serves as our CI/CD tool for automating the deployment pipeline. We’ve configured Jenkins to continuously integrate code changes, run automated tests, and deploy the ChatBOT application to EKS. By automating the deployment process, Jenkins accelerates the delivery of updates and enhancements, improving efficiency and reliability.

**4\. DevSecOps Practices:** Throughout the deployment pipeline, we’re integrating security practices into every stage to ensure the security of our ChatBOT application. This includes vulnerability scanning, code analysis, and security testing to identify and mitigate potential security threats early in the development lifecycle.

By implementing DevSecOps practices and leveraging modern technologies like Kubernetes, Docker, and Jenkins, we’re ensuring the secure, scalable, and efficient deployment of ChatBOT, enhancing user engagement and satisfaction.

# **STEPS:**

**Step:1 :- Create Jenkins Server.**

1. Clone the GitHub repository.

**GITHUB REPO**: [Chatbot-UI]
https://github.com/DevOps-010/Anshuman-DevopsMajor-1.git
```bash
git clone https://github.com/DevOps-010/Anshuman-DevopsMajor-1.git
cd Chatbot-UI
```

2\. Before proceeding to next steps. Do the following things.

i. Create a DynamoDB table named “Lock-Files”.  
ii. Create a Key-Pair and download the PEM file.  
iii. Create a user and save the access keys.  
iv. Create an S3 bucket.  
v. Download Terraform and AWS CLI.

```bash
# Terraform Installation Script
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y

# AWS CLI Installation Script
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
```

3\. Modify the `backend.tf` file in the `EKS-TF` directory to update the **bucket** name and **DynamoDB** table.

```hcl
terraform {
  backend "s3" {
    bucket         = "<your-s3-bucket-name>"
    region         = "us-east-1"
    key            = "Chatbot-UI/EKS-TF/terraform.tfstate"
    dynamodb_table = "Lock-Files"
    encrypt        = true
  }
}
```

4\. **Configure AWS CLI:** Run the below command, and add your access keys.

```bash
aws configure
```

5\. Replace the PEM file name in the Terraform variables file (`variables.tfvars`) with the one already created on AWS.

6\. Initialize the backend by running the below command.

```bash
cd EKS-TF
terraform init
```

7\. Run the below command to get the blueprint of what kind of AWS services will be created.

```bash
terraform plan -var-file=variables.tfvars
```

8\. Now, run the below command to create the infrastructure on AWS Cloud.

```bash
terraform apply -var-file=variables.tfvars --auto-approve
```

9\. Upon success, this will create an EC2 server with the name “Jenkins-server”.

10\. Connect to it with SSH.

**Step:2 :- Configure Jenkins server.**

1. Access Jenkins on port 8080 of EC2 public IP.

```bash
http://<ec2-public-ip>:8080
```

2\. Run the below command to get the administrator password and paste it into Jenkins.

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

3\. Install suggested plugins.

4\. Create user help us customize username and password of Jenkins.

5\. Save and Continue all the rest.

6\. Access SonarQube on port 9000 of the same Jenkins server.

```bash
Username: admin
Password: admin
```

7\. Customize the password.

8\. Navigate to Security → Users → Administrator.

9\. Click on Tokens.

10\. Create one and save it.

11\. Now go to Configuration → Webhooks → Create

```bash
Name: Jenkins
URL : http://<public_ip>:8080/sonarqube-webhook/
```

12\. Then configure webhook and create.

13\. Now in Jenkins Navigate to Manage Jenkins → Plugins → Available Plugins and install the following.

14\. Restart Jenkins after they got installed.

15\. Go to Manage Jenkins → Tools → Install JDK(17) and NodeJs(19) → Click on Apply and Save.

16\. Similarly install DP-check, Sonar-Scanner, and Docker.

17\. Go to Jenkins Dashboard → Manage Jenkins → Credentials. Add

Sonar-token as secret text.

Docker credentials.

GitHub Credentials.

AWS access keys as AWS Credentials.

18\. Manage Jenkins → Tools → SonarQube Scanner. Then add sonar-server and created sonar-token.

**Step :3 :- Create Jenkins Pipeline**

1. Create a new pipeline in Jenkins.

```bash
Definition: Pipeline script from SCM
SCM : Git
Repo URL : https://github.com/NotHarshhaa/DevOps-Projects/DevOps-Project-28/Chatbot-UI.git
Credentials: Created GitHub Credentials
Branch: main
Path: JenkinsFile/Chatbot-Jenkinsfile
```

2\. Click on “Build”.

3\. Upon successful execution you can see all stages as green.

**Step:4 :- Create EKS Cluster with Jenkins**

1. Create a new pipeline in Jenkins.

```bash
Definition: Pipeline script from SCM
SCM : Git
Repo URL : https://github.com/DevOps-010/Anshuman-DevopsMajor-1.git
Credentials: Created GitHub Credentials
Branch: main
Path: JenkinsFile/EKS-Jenkinsfile
```

2\. Click on “Build” and verify the cluster creation.

3\. This will create a cluster in AWS.

4\. Now In the Jenkins server. Give this command to add context.

```bash
aws eks update-kubeconfig --name <clustername> --region <region>
```

5\. It will Generate an Kubernetes configuration file.  
Navigate to the path of config file and copy it.

```bash
cd .kube
cat config
```

6\. Save it in your local file explorer, at your desired location with any name as text file.

7\. Now in Jenkins Console add this file in Credentials section with id k8s as secret file.

**Step:5 :- Deployment on EKS**

1\. Add the deployment stage in the Jenkinsfile.

```groovy
stage('Deploy to kubernetes') {
    steps {
        withAWS(credentials: 'aws-key', region: 'asia-south-1') {
            script {
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                    sh 'kubectl apply -f k8s/chatbot-ui.yaml'
                }
            }
        }
    }
}
```

2\. Rerun the Jenkins pipeline and verify the deployment.

3\. This will create all the resources in the Cluster.

```bash
kubectl get all
```

4\. This will create a Classic Load Balancer on AWS Console.

5\. Copy the DNS Name and Paste it on your browser and use it.

**Step: 6 :- Clean Up**

1. Delete the EKS Cluster by selecting the `destroy` option in the Jenkins pipeline.

2\. Destroy the Jenkins server by running the following command locally:

```bash
terraform destroy -auto-approve -var-file=variables.tfvars
```

---
