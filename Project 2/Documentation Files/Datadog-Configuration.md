Installation:
DD_API_KEY=***** bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh)"
This command will install several items, to get the agent up and running.
The API_KEY must be replaced with our actual api key, which I will not put here
for security reasons. However, the use of the key ensures that no matter what 
instance you install the agent on it will always connect back to our 
datadog dashboard.

Configuration Files:
https://docs.datadoghq.com/integrations/nginx/
This documentation from the official site details setting up configuration files
to allow us to gather metrics from nginx.

conf.yaml:
The most important of the docs, it directs the agent to the server. From the 
agent's perspective, it is running locally and therefore, you set it to scan
localhost so it scans itself and sends the metrics to dd-hq. 
Three things to note here: 
	1. It needs to be told to listen on an open port. I had it set to port 81 as 
	the guide directs, which was not open on our instance. Nonetheless, it was
	able to gather metrics. More testing required.
	2. The doc will tell you to set stub_status; but it must be stub_status on;
	for out version of datadog
	3. /nginx_status: later, this will be a part of a url on our private networks
	to collect metrics (localhost/nginx_status) it cannot and is not supposed
	to be accessed publicly

datadog.yaml:
Contains a ton of comments by default, but the only real thing of note here is 
to set logs_enabled: true

conf.yaml:
Must contain the complete url, including localhost, port and /nginx_status as
well as pathing to the access and error logs of nginx. The comments contain
the default paths, so you should be able to just uncomment them when setting
up the file.