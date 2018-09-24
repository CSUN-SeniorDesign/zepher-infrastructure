Most direction came from the official Ansible documentation website: 
	https://docs.ansible.com/ansible/latest/modules/modules_by_category.html
Ansible uses a large collection of "modules" which run commands 
	as specified by the user. These can be either be Ansible specific, or can tell it
	to use 3rd party programs such as git.
As the all Ansible related files are located in /etc/ansible, it is important to
	note that when editing them, you must use sudo or be root. This is not required
	to run the playbook however.
To run the playbook, use the command ansible-playbook <filename>
	-i can be used to tell the playbook to use a particular inventory. Otherwise,
	it uses the hosts file.

I will now go through my .yml to explain some of methodology

---: ansible files require --- at the top of the file to be run
- hosts:
Probably the most important module as it tells the playbook on which machine it needs
	to be running on. If the tags in your inventory file are not set right, or you
	do not properly switch between them when writing a playbook, the files you create
	or alter will not be in the proper place
	
tasks: 
Declares the beginning of the tasks related to the hosts

- name:
The name of the task

***IMPORTANT NOTE***
yaml files are HIGHLY strict about spacing and indentation. If not properly spaced, 
	you will be barraged with errors. Using a program such as yamllint 
	is recommended until you get the hang of the spacing.
	
file:
A module that relates to altering files. In this case, it is used to delete a file
	state: is used to tell the machine what you WANT the file to be in, rather than
	what it is. in this case state: absent means you want the file to be absent
{{lookup('env','HOME')}} is used a number of times. {{}} is how commands are used in
	ansible outside of the command module. the command lookup('env','HOME') is used
	to look up the variable HOME in env, and replace the command with that value.
	When used in a directory, the whole directory must be in quotations "". 
	> This is used to make the playbook more dynamic, rather than hard coding directory
	paths, the playbook will always run in the user's home directory.

git:
A module that utilizes git. This playbook assumes the user already has git installed
	-repo: the repository desired to clone
	-dest: where you want it downloaded
	-version: the branch
	-accept-hostkey: yes , tells it want to use a file on the host
	-key_file: directs the playbook to a file. In this case, I decided that all users
		that use this playbook must have their GitHub personal access token in a file
		named PAT to make transitioning easier.

apt:
functions like apt-get
	name: the apt you want
	state: present , get it
	
command: 
runs a command on the console

become-user:
self-explanatory

unarchive:
unarchives a file, be it .zip, .gz.tar, etc.
	src: the file to be unarchived. by default, it looks on the local host
	remote-src: yes , not used, but can be, if the file to unzip is on the target host
	dest: by default on the target host specified by the last -host: