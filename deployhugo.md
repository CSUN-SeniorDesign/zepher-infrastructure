---
title: "Deploy Hugo"
author: "Author Name"
cover: "/img/cover.jpg"
tags: ["tagA", "tagB"]
date: 2018-09-08T02:39:21Z
draft: false
---

	Deploying the Hugo Website

	Overview:

		- A guide to deploy hugo static website into a domain.

	Prerequisite:

		- You are required to finish the “SetupHugo.md” before proceeding into deploying hugo in the website.

	Steps: 

		- Create static files of Hugo website by the following command:

			Hugo (Note: This command will create a public directory inside the hugo site.)

		- Move public directory files to the web server:

			Cp <Nameofthesite>/public/* /var/www/html

		- Verify Domain and the blog should appear.



