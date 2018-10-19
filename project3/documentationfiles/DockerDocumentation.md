Dockerfile setup

<h1>Dockerfile Setup with Hugo and Nginx</h1>
A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. A Docker container image is a lightweight, standalone, executable package of software that includes everything needed to run an application: code, runtime, system tools, system libraries and settings.


<h2>Overview:</h2>
By the end of this guide the user will be able to deploy a container with Hugo and Nginx images.

<h2>Prerequisites:</h2>

•   A Ubuntu machine 

•   Docker installed

•   AWS access (Optional)

<h2>Guide:</h2>
<h3>Pre-Requisites</h3>

To be able to use and run any container you're going to need to install Docker on your Ubuntu machine. You'll want to update Ubuntu before installing Docker so we are using the most up to date software.

To begin we will be in root.
~~~
Sudo su
~~~

 Then run the "update" and upgrade" to grab the updates needed.
~~~
apt-get update
apt-get upgrade
~~~

After upgrading we are now able to install Docker. To do so we will run this command.
~~~
apt-get install -y docker.io
~~~

The previous command will install Docker but we will want Docker to run when our machine boots. To do this we will run the command

~~~
systemctl start docker
systemctl enable docker
~~~

Now we have Docker and it will run whenever we boot our machine up. We can now begin working on our containers.

<h3>Docker installation Check and Test</h3>

Before we begin building the container that would contain Hugo and Nginx we will want to check if our Docker was installed properly. If you haven't already done so you can follow the documentation provided by Docker for a tutorial and check to do your first container : https://docs.docker.com/get-started/

To do the check for Docker and see if it works properly we will grab a container called "hello-world"

To check your version to see if Docker is installed run:
~~~
docker --version
~~~
Output should be Dockers version and build. Running "docker info" will provide you with additional information of your Docker installation.

To download and test Docker run:
~~~
docker run hello-world
~~~

This will download an image that isn't found locally from a public repository from the https://hub.docker.com/
You can check the images on your local machine after downloading:
~~~
docker image ls
~~~
You should then see the image "hello-world" that we just downloaded. We will then run it to see if Docker can properly do so.
~~~
docker run hello-world
~~~
If it properly runs you're ready to begin with the rest of this tutorial, otherwise you will need to troubleshoot and fix Docker.

<h3> Docker with Hugo</h3>
We will dive into some advanced forms of containerization. Going from a regular container like you saw with the hello-world image to something called a Multi-Stage container. 

Usually an image will contain one FROM statement to reference a base image that you will be using. In a Multi-Stage container you will be using multiple FROM statements to reference multiple base images at different points in your container.

A benefit of this is that your container size will be smaller if your were to have run two separate images as well as making it easier for you to reference information in one container than having to do so in two different containers.

You will begin by creating an empty directory where we will be working.
~~~
mkdir anywhere/you/want/nameit
~~~
You will then create a "Dockerfile" file which will container our instructions for our container
~~~
vim Dockerfile
~~~
Then we shall begin creating a Docker image that will contain Hugo and Nginx.
~~~
FROM alpine:3.5 as build

ENV HUGO_VERSION 0.49.1
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.tar.gz

# Install Hugo
RUN set -x && \
  apk add --update wget ca-certificates && \
  wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} && \
  tar xzf ${HUGO_BINARY} && \
  rm -r ${HUGO_BINARY} && \
  mv hugo /usr/bin && \
  apk del wget ca-certificates && \
  rm /var/cache/apk/*

#Grabs your blog and puts it into site
COPY blog /site/

WORKDIR /site

#Builds your blog
RUN /usr/bin/hugo
~~~
We will break down this beginning section of our Multi-stage image.
~~~
FROM alpine:3.5 as build
~~~
Grabs alpine version3.5 as our base image. This is then called "build" so if you needed to reference (which will be needed) this somewhere else you can by calling "build"

~~~
ENV HUGO_VERSION 0.49.1
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.tar.gz
~~~
These are environment variables that are being declared in the beginning of the instructions. That are used later in the code. They setup the version of Hugo we want to download which can be changed here if you wanted a different one. As well as setup the proper name for the binary that we will be grabbing from GitHub.

~~~
# Install Hugo
RUN set -x && \
  apk add --update wget ca-certificates && \
  wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} && \
  tar xzf ${HUGO_BINARY} && \
  rm -r ${HUGO_BINARY} && \
  mv hugo /usr/bin && \
  apk del wget ca-certificates && \
  rm /var/cache/apk/*
~~~
This section installs CA certificates then Hugo by grabbing it from the GitHub. It does the installation by grabbing the Tar file at the link and then unzipping the tar. After all this is done it deletes the tar.
~~~
#Grabs your blog and puts it into site
COPY blog /site/

WORKDIR /site

#Builds your blog
RUN /usr/bin/hugo
~~~
This next section requires some attention. In the same directory you created this "Dockerfile" you will want to create another directory called "blog" and put the files you want Hugo to use to build your site. In this section of the Docker image it will look for "blog" in the directory it's in and then transfer that to the directory "site" inside the container. It will then go into "site" and run "hugo" building your site. 

If this is done correctly and after you're done with your "Dockerfile" you will then run while in the directory of the "Dockerfile" and "blog" directory:
~~~
docker build -t givemeaname .
~~~
Then
~~~
docker run -d -p 1313:80 thenameusedabove
~~~
This command will run the container independently in the background and port 1313 will be pushed to 80. So when checking to see if your Hugo setup your site correctly you go to https://localhost:1313. If you see your site you did this section properly otherwise you will need to troubleshoot and figure out the issue. 

One issue can be the ports. Somewhere in Docker file you will probably want to add these lines to open the ports
~~~
EXPOSE 80
EXPOSE 1313
~~~ 

<h3> Docker with Hugo and Nginx!</h3>
Similar to what we did before we are going to add onto our "Dockerfile" to include Nginx after the Hugo portion. We will then use a configuration file to setup the site properly.

In the same "Dockerfile" add this below the last line:
~~~
FROM nginx:alpine

COPY default.conf /etc/nginx/conf.d/default.conf

COPY --from=build /site/public /var/www/site

WORKDIR /var/www/site

RUN ls -al 
~~~
This section will install Nginx using the base image found on the Docker hub. This is Nginx's official image on Docker.


~~~
COPY default.conf /etc/nginx/conf.d/default.conf

COPY --from=build /site/public /var/www/site
~~~
The first copy command will need our help. This will look for a "default.conf" in the same directory it's in, just like the Hugo section. This time we will have to create a file called "default.conf" and then place in the Nginx configuration information.

Your "default.conf" should look like this:
~~~
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /var/www/site;
        index  index.html index.htm;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
~~~

The second copy command will reference the previous image by using the "--from=build" and grab what's inside that image in the public directory and put it into the current image in the site directory. It will then change our working directory to the site and list it's contents as a check to see if everything moved.

Then run 
~~~
docker build -t givemeaname .
~~~
Then
~~~
docker run -d -p 1313:80 thenameusedabove
~~~
If everything worked out going to https://localhost:1313 we will see our site once again. If you were to comment out the copy command that grabs our Hugo stuff you would just see the Nginx default site.
