Create base AMI using Packer	
	Overview:
		By the end of this tutorial the reader should be to able to setup following:
		
			- Create base AMI 
			- Add scripts provisioner
			- Add commands provisioner
			- Add files provisioner
	
	Prerequisites:
		Computer with Windows Operating System
		AWS account
    		Create one as a student for $100 free credit: https://www.awseducate.com/registration#APP_TYPE

	Steps:
		1. Installing Packer:
				
				1. https://www.packer.io/downloads.html
				2. Click on Windows 64bit
				3. unzip to Documents
				4. Edit Environment varible to add the unzip packer file into PATH varible.
		
		2. Create a .json extension file with any name that want
			
			1. Add variables to be used for buliders (Note: Access_key and secret_key is configure with aws cli using aws configure command)
				
				"variables": {                                                                    
					  "name": "zephyr90done",                                                   
					  "source_ami": "ami-0e32ec5bc225539f5",                                          
					  "access_key":"",                                                                
					  "secret_key":"",                                                                
					  "region":"us-west-2"                                                            
					},  
					
			2. Add builders to use ubuntu as base which will start an ubuntu instance on ec2 using the access key and secret key.
		
				"builders": [{                                                                    
					  "type": "amazon-ebs",                                                           
					  "access_key": "{{user `access_key`}}",                                          
					  "secret_key":"{{user `secret_key`}}",                                           
					  "ami_name": "{{user `name`}}",                                                  
					  "region": "{{user `region`}}",                                                  
					  "source_ami": "{{user `source_ami`}}",                                          
					  "instance_type": "t2.micro",                                                    
					  "communicator": "ssh",                                                          
					  "ssh_username": "ubuntu",                                                       
					  "run_tags":{"Name":"packer-image"}                                              
					}], 
					
			3. Create a provisioners:
				1. Adding file provisioner:                                                                    
					{                                                                     
						"type": "file",                                                           
						"source": "C:\\Users\\Neel\\Downloads\\cmder\\bin\\packer\\conf.yaml",                                        
						"destination" : "/home/ubuntu/conf.yaml"                           
					}, 
					
					Notes:
						 Source - where the file is located in local os
						 destination - where the file will be located in the ubuntu instance
						
				2. Shell commands provisioner:
				
					{                                                                             
						"type": "shell",                                                          
						"inline": ["sudo apt-get install nginx -y","sudo systemctl enable nginx", "sudo systemctl start nginx"]
					},
					
					Notes:
						 inline - run each commands in shell
					
				3. Script provisioner:
					
					{                                                                     
						"type": "shell",                                                          
						"script" : "C:\\Users\\Neel\\Downloads\\cmder\\bin\\packer\\movingfiles.sh"
					}, 
					
	Special Notes: Packer is a program to create a base AMI which will create an instance on ec2 and do all the provisioners you define and then
					it packages back to give us an AMI which can be used to create instance that has been configured to do something. In our case west-2
					had an AMI image with only nginx and datagog installed, so whenever we created an instance using that AMI it will already have nginx
					and Datadog pre-installed.
			