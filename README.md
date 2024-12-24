<!-- project title and its describtion-->
# **CI_PIPELINE**
* Build and deploy a simple web application on 2 vagrant machines using a CI pipeline.
---
<!-- required tools -->
 | **Tool 1**   | **Tool 2**   | **Tool 3**   | **Tool 4**   | **Tool 5**   | **Tool 6** | **Tool 7** |
 |--------------|--------------|--------------|--------------|--------------|------------|------------|
 | Vagrant      | VirtualBox   | Docker       | Jenkins      | Ansible      | Git        | Python     |
 
<!-- project steps that i followed -->
## How can I Start a project like this?
### You should follow these steps:
#### 1. Push python code, requirements, templates and static folder to a new GitHub private repository:
* first you need to create a private repo with a Readme file with an extention (.md).
* create your working directory and put your project files on it.
* connect the vm to your github account `git config --global user.name "Your Name"` , `git config --global user.email "your-email@example.com"
` , making the secure connection with the `ssh-keygen` , `eval "$(ssh-agent -s)"` , `ssh-add ~/.ssh/id_rsa
` , `cat ~/.ssh/id_rsa.pub` , copy and pate in your new ssh key 
* cloning the remote repo in your local branch `git clone <ssh url>`

---

#### 2. Write a Dockerfile to containerize the application and push it to your repo.
* create a file in your directory called 'Dockerfile' without any extenstion.
* edit this file with any editor you want, and you should follow this sequence 
    1. Set the base image in our case we need `python:3.9`
    1. Set the working directory `WORKDIR /app`
    1. Copy your dependencies and requirements `COPY requirements.txt /app/`
    1. Install dependencies `RUN pip install --no-cache-dir -r requirements.txt`
    1. Copy the application code, templates, and static folder into the container `COPY . /app/`
    1. Expose the port the app runs on `EXPOSE 5000`
    1. Specify the command to run the app `CMD ["python", "app.py"]`
    1. Build the Docker image `docker build -t <image_name> <path_to_dockerfile> `  

    1. Run the Docker container `docker run -d -p 5000:5000 <image_name>  ` ![My local image](https://github.com/maryMICH2/CI_PIPELINE/blob/main/screenshots/after%20adding%20the%20api%20key%20to%20the%20app.py%20code.PNG?raw=true)
    ![My local image](https://github.com/maryMICH2/CI_PIPELINE/blob/main/screenshots/after%20adding%20the%20static%20folder%20with%20a%20plot.png%20file.PNG?raw=true)





---
#### 3. Make two vagrant machines with low specs.
* Create a directory for your Vagrant project.
* Initialize a Vagrant project `vagrant init` .
* Edit the Vagrantfile to define two machines with low specs on any linux distrubution you want.
* Start the machines `vagrant up`.
---
#### 4. Set up a Jenkins pipeline.
* Pull code from a Git repository.
```
stage('Checkout Code') {
            steps {
                echo 'Checking out the code..'
                git branch: 'main', credentialsId: 'my git Credential', url: 'https://github.com/maryMICH2/CI_PIPELINE.git'
                
            }
        }
``` 
* Build a Docker image.
```
        stage('Build Docker Image') {
            steps {
                echo 'Building the image.. '
                sh "docker build -t marriy/first_repo:latest ."
            }
        }
```
* Push the image to Docker Hub.
```
stage('Push to Docker Hub') {
            steps {
                echo 'pushing the image.. '
                withCredentials([usernamePassword(credentialsId: 'dockerhup_credential', passwordVariable: 'password', usernameVariable: 'username')]) {
                    sh "docker login -u $username -p $password"
                    sh "docker push marriy/first_repo:latest"
                }
            }
}
```
---
* Run ansible playbook that do the following 

1. Installing docker on the two-target vagrant machine using ansible.

```
---
- name: Install Docker on CentOS VMs
  hosts: myservers
  become: yes  # Use sudo
  tasks:
    - name: Remove podman-docker if installed
      yum:
        name: podman-docker
        state: absent
      ignore_errors: yes

    - name: Install required packages
      yum:
        name:
          - yum-utils
          - device-mapper-persistent-data
          - lvm2
        state: present

    - name: Set up the Docker repository
      command: yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    - name: Install Docker
      yum:
        name: docker-ce
        state: present

    - name: Add user to docker group
      command: usermod -aG docker {{ ansible_user }}
      ignore_errors: yes

    - name: Start Docker service
      service:
        name: docker
        state: started
        enabled: yes

    - name: Restart Docker service
      service:
        name: docker
        state: restarted
```
2. Pull the docker image from Dockerhub on the two target machines.
```
- name: Pull Docker image from Docker Hub
      docker_image:
        name: marriy/first_repo
        tag: latest
        source: pull
```
3. Run docker container from image on the two machines.
```
- name: Run Docker container from image
      docker_container:
        name: first_repo_container
        image: "marriy/first_repo:latest"
        state: started
        restart_policy: always
        published_ports:
          - "5000:5000"
```
---
<!-- screenshots-->
* ### Ansible cofiguration:
---
1. ansible playbook installing docker
![My local image](https://github.com/maryMICH2/CI_PIPELINE/blob/main/screenshots/ansible%20playbook%20installing%20docker.PNG?raw=true)

2. docker versions on 2 machines
![My local image](https://github.com/maryMICH2/CI_PIPELINE/blob/main/screenshots/docker%20versions%20on%202%20machines.PNG?raw=true)

3. pull the images and run containers
![My local image](https://github.com/maryMICH2/CI_PIPELINE/blob/main/screenshots/pull%20the%20images%20and%20run%20containers.PNG?raw=true)

---
* ### Jenkins pipeline:
---
![My local image](https://github.com/maryMICH2/CI_PIPELINE/blob/main/screenshots/my%20pipeline.PNG?raw=true)

---

* ### Final results:
---
1. the application from m01
![My local image](https://github.com/maryMICH2/CI_PIPELINE/blob/main/screenshots/data%20from%20m01.PNG?raw=true)
![My local image](https://github.com/maryMICH2/CI_PIPELINE/blob/main/screenshots/charts%20from%20m01.PNG?raw=true)

2. the application from m02
![My local image](https://github.com/maryMICH2/CI_PIPELINE/blob/main/screenshots/data%20from%20m02.PNG?raw=true)
![My local image](https://github.com/maryMICH2/CI_PIPELINE/blob/main/screenshots/charts%20from%20m02.PNG?raw=true)

---

