---
title: "CircleCI to ECR"
author: "Tonny Wong"
cover: "/img/cover.jpg"
tags: ["tagA", "tagB"]
date: 2018-10-19T15:15:35-07:00
draft: false
---

	Setup CircleCI for automation:
	
		You will need to setup CircleCI for automation build and push blog post for every commit in the master. 
		You will need to build out a configuration file so that CircleCI will do automated steps for every commit in master branch.
		
		Overview:
			By the end of this tutorial the reader should be to able to setup following CircleCI configurations:
			
				1. Install git, python and aws cli.
				2. Install docker
				3. Run docker image in CircleCI
				4. Log in into your ECR
				5. Tag the docker image and push it to the ECR
				6. Push the tarball up to Amazon S3 to a designated location, using a restricted set of

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
		
		- Installing all necessary components for hugo same as project 0 ,1 and 2:
		
			version: 2
			jobs:
				build:
					machine: true
					steps:
						- run:
							name: installing git
							command: |
								if [ "${CIRCLE_BRANCH}" == "master" ]; then
									sudo pip install awscli
									sudo apt-get install git
									sudo apt-get install python3
									python --version
									sudo pip install awscli              
								fi
							
		- When installing Docker file we would want the latest version of docker and some components that docker will need for the necesary functions:
					
				  - run:
					  name: installing docker 
					  command: |
						if [ "${CIRCLE_BRANCH}" == "master" ]; then
							sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
							sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
							sudo apt-get update
							sudo apt-get install -y docker-ce
							sudo usermod -a -G docker ubuntu
							docker info
						fi
							
        - checkout will grab our most recent updated github master branch:
		
					- checkout #this is to checkout the current most updated github master branch 
					
		- Now we will build the docker image but in some case I required to make a extra step due to folder naming due to case sensitivity.
		
					- run:
					  name: Creating Docker Image
					  command: |
						if [ "${CIRCLE_BRANCH}" == "master" ]; then
							sudo pwd
							sudo ls -al
							mv /home/circleci/project/Project1 /home/circleci/project/project1
							cd /home/circleci/project/project1
							sudo docker build -t project1 .
						fi

		- Now we are able to manage with the ECR. First login to the ECR 
		
					eval $(aws ecr get-login --no-include-email --region us-west-2)
					
		- Then you are able to tag the image which will be latest and then push it into our ECR.
		
						if [ "${CIRCLE_BRANCH}" == "master" ]; then
							cd /home/circleci/project/project1
							sudo docker images
							sudo pwd
							sudo docker tag project1:latest $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/zephyrecr:latest
							sudo docker push $AWS_ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/zephyrecr:latest
						fi
				