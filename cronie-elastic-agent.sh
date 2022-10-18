#!bin/bash
# Restarting elastic-agent
sudo systemctl restart elastic-agent
sudo systemctl is-active --quiet elastic-agent && echo Service is running

