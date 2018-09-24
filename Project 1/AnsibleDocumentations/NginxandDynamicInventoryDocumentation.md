<h1>Setup Ansible Nginx install and Dynamic Inventory</h1>
Ansible is open source software that allows automation using modules and playbooks. This allows us to automate certain aspects of AWS which allows us to scale up. The reason for this is you automate the aspects that would be tedious by hand and would require a significant amount of time if done manually. In this documentation we are going to cover how to install nginx onto an instance as well as creating a Dynamic Inventory for Ansible to use.

<h2>Overview:</h2>
By the end of this guide the user should be able to understand and create a playbook to install nginx. As well as create a Dynamic inventory host file for Ansible.
 
<h2>Prerequisites:</h2>

•	A Linux machine

•	Ansible installed

•	AWS access to the instance and Account


<h2>Steps:</h2>

<h3>1.	Installing Ansible</h3>

- **Go to your terminal and Type**

          sudo apt-get update
          sudo apt-get install software-properties-common
          sudo apt-add-repository ppa:ansible/ansible
          sudo apt-get update
          sudo apt-get install ansible

   *update*: Updates your files so they are up-to-date
  
   *software-properties-common*: Install what ansible needs such as python
  
   *apt-get-repository ppa:ansible/ansible*: Creates a repository for ansible
  
  *ansible*: Finally installs Ansible on your machine.
  
- **Creating a Playbook and Configuring your Host File**

    **a.**	Ansible uses playbooks that users create in order to do tasks. Within this playbook you tell Ansible who you want to target, who you want ansible to be, and what tasks you want it to do.
        Go to your ansible folder, if it’s not there you can create one
        
          cd /etc/ansible or mkdir /etc/ansible

    **b.**	 Within the folder you will find that it should contain a couple of files.
    
          ansible.cfg hosts 

    The hosts file contains the IP’s we want our playbook to target and the ansible.cfg contains some configuration options that you can edit. For now we will have to edit the hosts file for our playbook to work.

    **c.**	Use a text editor to edit hosts
    
          sudo vim hosts

	The hosts file has a couple of formatting option we can work with:
    
    We can create tags that references group of IP’s. These tags are marked by brackets and directly under them the group of IP’s we want associated with this tag.
    
            [webserver]
            192.58.146
            192.65.58

    Otherwise we just give an alias and have the IP next to it.

            ec2_instance 192.58.46

    Whichever method is chosen we will have to remember the tag or alias to use in our playbook. 	
		
    **d.**	If accessing AWS using Ansible it will use SSH which would require a private key to have access.
    
            sudo vim ansible.cfg
		
    Under the [default] tag you will want to add the path to your private key and add who the user will be. In this case since we are using AWS it would be ubuntu.
    
	         [defaults]
		     private_key_file=path/to/your/key.pem
		     remote_user=ubuntu

    This allows Ansible to access the AWS instance as ubuntu user.

    **e.**	After we will want to actually create the playbook. While in the Ansible folder you will want to create the actual playbook.
    
	        sudo vim nginx.ylm

    The playbooks need to have the extension “ylm” because this is the format that Ansible uses. The language used to create the playbook is actually very easy to read and understand. Since it is using the YAML language you will have to follow the syntax rules for the language. The code we will be using is here:

---
	- hosts: webserver
	  become: yes
	  tasks:
	    - name: Installs Nginx web server
	      apt: pkg=nginx state=installed update_cache=true
	      notify:
	        - start nginx
	

	  handlers:
	    - name: start nginx
	      service: name=nginx state=started
        
        
        
	
   *hosts*: Determines who we want to target. In this case we are referencing our webserver tag in our hosts file.
    
   *become*: Gives us higher privileges while being the user we assigned. In this case ubuntu
    
   *tasks*: The tasks lists everything we want the playbook to do. In this case we are installing Nginx to the instance on AWS.
    
-	**Dynamic Inventory**

    **a.**	Dynamic inventory allows us to remove the manual requirement when dealing with our hosts file. This is useful when our instances are constantly changing. What this file will do is will find all the instances running on our AWS and then list them using tags.

    **b.**	You will need to download two files in order to get Dynamic inventory to work.

        ec2.py : https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py
        ec2.ini: https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini
        
      ec2.py is the script that we will run in order grab our instance IP from AWS
      
      ec2.ini is the configuration file that ec2.py will use to determine what to grab.

    **c.**	You will have to read through the ec2.ini and ec2.py to familiarize yourself with what it can do. Editing the ec2.ini to make ec2.py do for you.

    **d.**	Just like our hosts file we will need to give permission to Ansible to do so. The difference now is we need to get a access key and a secret access key from AWS.
    
        https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html
        
    Afterwards in your Terminal:
    
	      export AWS_ACCESS_KEY_ID=’AL123’
	      export AWS_SECRET_ACCESS_KEY=’afg1234’
        
    This will change the variables that the script accesses to use to enter AWS.

    **e.**	After all this you can run the script and you’ll be able to see the instances it grabbed.
    
    **Troubleshoot**: if you cannot run the script you might need to give it the execution permission
    
	       sudo chmod +x ec2.py
