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

    1. Run the Docker container `docker run -d -p 5000:5000 <image_name>  ` ![My local image](images/my_image.jpg)
    ![My local image](images/my_image.jpg)





---
#### 3. Make two vagrant machines with low specs.
* Create a directory for your Vagrant project.
* Initialize a Vagrant project `vagrant init` .
* Edit the Vagrantfile to define two machines with low specs on any linux distrubution you want.
* Start the machines `vagrant up`.
---
#### 4. Set up a Jenkins pipeline.

