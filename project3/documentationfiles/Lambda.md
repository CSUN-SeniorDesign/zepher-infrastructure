AWS Lambda:

Allows you to run code without provisioning or managing servers. Only asked to pay if the code is running. It can run codes for virtual machines or different backend services. You can set up your code to automatically trigger from other AWS services.

We will be running a python code on AWS Lambda to progressively update a site and verify upcoming changes in which Lamda will listen to these events in order to trigger.


These are the necessary components for the lambda to function for a automated website: 


S3 Bucket:
https://github.com/CSUN-SeniorDesign/zephyr-infrastructure/tree/master/Project%201/Terraform%20Files 

ECS:
https://github.com/CSUN-SeniorDesign/zephyr-infrastructure/blob/master/project3/documentationfiles/ECSdoc.md 
https://github.com/CSUN-SeniorDesign/zephyr-infrastructure/blob/master/project3/documentationfiles/ECS-ASG-Setup.md 

ECR:
https://github.com/CSUN-SeniorDesign/zephyr-infrastructure/blob/master/project3/documentationfiles/ECSdoc.md 

Terraform:
https://github.com/CSUN-SeniorDesign/zephyr-infrastructure/tree/master/Project%201/Terraform%20Documentations 
	
  Docker
https://github.com/CSUN-SeniorDesign/zephyr-infrastructure/blob/master/project3/documentationfiles/DockerDocumentation.md 
	
  CircleCI: 
https://github.com/CSUN-SeniorDesign/zephyr-infrastructure/blob/master/project3/documentationfiles/CircleCIDocumentation.md 

**Now we will start Lambda using a method through AWS**

This method will use AWS Lambda console to setup your Lambda. This is quick and easy but isn’t easy to update if needed. Using Terraform and CircleCI makes updating your Lambda efficient and quicker.

We will first need to head to the console for AWS Lambda:
	https://aws.amazon.com/lambda/ 

Clicking “Get Started” will take you where you need to be to begin creating Functions.
On the next screen you can click “Create Function”
On this screen you have the option to :
Create a Function from scratch using the “Author from Scratch”
Choose a template for a Function as a starting point using “Blueprints”
Or use the public repository and choose a publish function using “AWS Serverless Application repository”

Depending on what type a function you’re looking for or your experience each one of these avenues can be beneficial starting point.

For this example we will choose “Author from Scratch”
Below you will have to “name” your function
Choose a runtime, in this case “python 3.6”
Choose a role. You can create one and give it permission suited for your function or choose from one of the other options. This example we will choose “Create a new role from one or more templates” and then name it “lambda_basic_execution”
Then create function.

This will create a basic Hello world Function. You can test it by clicking at the top right “Configure Test Event” from the drop down.

Selecting Hello world as a template and providing a name for it. Then click Create. Then click Test.

This is a simplification of Lambda just using the Lambda Console.
