#!/bin/bash
echo "Creating html page"
echo "Hello, World" > index.html
echo "Starting server"
nohup busybox httpd -f -p 8080 &