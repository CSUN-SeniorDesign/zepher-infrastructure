#!/bin/bash
-required for bash scripts

cd $HOME/zephyr/zephyr-blog/Project1/zephyr
-Goes to the desired directory in the previously created git repo
	-$HOME represents the directory the user has set to HOME when using the env command
	
rm -rf public/*
rm -rf public.tar.gz
-These commands clear the previously created public directory and tarball if they exist
	-rm -rf dir/* deletes the contents of a directory without deleting the directory 
	 itself

hugo
-runs the hugo command to remake the contents of the public directory

tar -czf public.tar.gz public/*
zips the contents of the public directory to public.tar.gz