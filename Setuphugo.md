---
title: "Setup Hugo"
author: "Author Name"
cover: "/img/cover.jpg"
tags: ["tagA", "tagB"]
date: 2018-09-08T01:50:32Z
draft: false
---

	Starting Hugo

	Overview:

		- A guide to create a hugo static website.

	Prerequisite:

		- First it is required to download Hugo (this can be done by obtaining a packet manager) and then you may verify the version on Hugo by:

			- Hugo version

	Steps: 

		- You are ready to start using Hugo and create a site, follow these commands to add a site and theme:

			Hugo new site <Name of the site>
			Cd <Name of the site>
			Git init
			Git submodule add <Weblink of the selected theme> themes/<nameofthetheme>

		- This will allow the theme to be downloaded on the sites files towards the theme file so that we can then copy the files in the selected theme towards the site. Then we will copy all the files from the theme to the site:

			Cp -R <nameofthesite>/themes/<nameoftheme>/* <nameofthesite>/

		- Configure the file config.toml file by changing the base url to a Domain if you own one and also add the corresponding theme that you selected this can be done by vim.

			Vim config.toml
			Theme = “<nameoftheme>”

		- You now have a site with a pre-built theme now you are welcome to create post into your blog using this command:

			Hugo new post/<nameofpost>.md
		 
		- After finish editing you can now test your site through the localhost post 1313.

			Hugo server -D

		- The -D stands for draft if you do not want to place this site into the original files.



