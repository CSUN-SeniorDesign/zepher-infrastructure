---
title: "Setup CircleCI"
author: "Tonny Wong"
cover: "/img/cover.jpg"
tags: ["tagA", "tagB"]
date: 2018-10-05T15:15:35-07:00
draft: false
---

	Setup CircleCI for automation:
	
		You will need to setup CircleCI for automation build and push blog post for every commit in the master. 
		You will need to build out a configuration file so that CircleCI will do automated steps for every commit in masater branch.
		
		Overview:
			By the end of this tutorial the reader should be to able to setup following CircleCI configurations:
			
				1. Install hugo on the CI system with a simple download of the Linux version
				2. Run hugo against your blog to generate that the blog is successfully created
				3. Make sure that hugo was successfully run
				4. Get the SHA of the current commit in the blog git repo (Does CircleCI do this
				   automatically for you?)
				5. Create a tarball of your public folder contents with a filename of "<commit-sha>.tar.gz".
				6. Push the tarball up to Amazon S3 to a designated location, using a restricted set of
			       credentials provided to CircleCI.
				7. Update something to tell the instances that there is a new version available in the
			       location they are setup to watch.

		Prerequisites:
			Computer with Windows Operating System
			AWS account
        		Create one as a student for $100 free credit: https://www.awseducate.com/registration#APP_TYPE
 
		Steps:
	
		- 	You are able to sign in to CircleCI with your github user.
		
		-	You are suppose to follow the designated CircleCI group if needed or you could work from it through your own github account repository.
		
			-	Create a CircleCI folder with a .yml extension. (The following instruction on how to start it should be in this link https://circleci.com/docs/2.0/getting-started/)
				- In the config.yml to test it is working you coul turn this in on the file:
				
					version: 2
					jobs:
						build:
							docker:
								- image: circleci/ruby:2.4.1
							steps:
								- checkout
								- run: echo "A first hello"
								
		- For a automated configuration to verify if files of a local moves to a s3 bucket here all all the parts with explanation of what each line would do:
		
		- Imagine running a instance and knowing which installations are required for your static site:
		
		- Installing all necessary components for hugo same as project 0 and 1:
		
		version: 2
			jobs:
				build:
					machine: true
				steps:
				
					- run:
						name: installing git  
						command: |
							sudo apt-get install git
					- run:
						name: installing python
						command: |
							sudo apt-get install python3
							python --version
      
					- run:
						name: installing aws cli 
						command: |
							sudo pip install awscli
							
		- When installing hugo we would want to delete the hugo install file after it is done so that errors would pop up less:	
		
					- run:
						name: install hugo  and removing the install file
						command: |
							sudo wget https://github.com/gohugoio/hugo/releases/download/v0.49/hugo_0.49_Linux-64bit.deb
							sudo apt-get install dpkg
							sudo dpkg -i hugo_0.49_Linux-64bit.deb
							cd /home/circleci/project
							sudo rm hugo_0.49_Linux-64bit.deb
							
        - checkout will grab our most recent updated github master branch:
		
					- checkout #this is to checkout the current most updated github master branch 
					
		- As any other clean up we would always want to clean the old public file and creating a new one after we create a tar file (zipping the file)
		
					- run:
						name: removing old public file and creating new one using hugo and zipping it using tar
						command: |
							cd /home/circleci/project/Project1/zephyr/
							sudo rm -r public/
							sudo hugo
							tar -zcvf $CIRCLE_SHA1.tar.gz public/
							
		- Now finally we can place it in our s3 bucket with our old tar, production file and upload file.
		
					- run:
						name: adding the tar file to s3 bucket 
						command: |
							aws s3 mv s3://zephyrproject2/circleciuploads/ s3://zephyrproject2/circleciuploadspast/ --recursive
							aws s3 mv s3://zephyrproject2/circleciproduction/ s3://zephyrproject2/circleciuploads/ --recursive
							aws s3 cp /home/circleci/project/Project1/zephyr/$CIRCLE_SHA1.tar.gz s3://zephyrproject2/circleciproduction/
	