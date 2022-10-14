# Setup of Elastic Agent
## Prerequisite
Install these tools before proceeding further.
- vim
- net-tools
- wget

## Installation
- Go to `Fleet` from `Management` section.
- After creating a Fleet,  click on `Add agent`.
- Select `Enroll in Fleet`
- Select default policy or any policy you might have created.
- Check the correct `Enrollment token` from `Authentication settings`.
- Download the Elastic Agent from the given download page.
- Go to your instance where Elastic Agent is going to be installed.
- Download the Elastic Agent using `wget` or `curl` command.
- Install that respective rpm package using following command
```shell
sudo rpm -vi <pkg.rpm>
```
- In order to enroll the Agent into the fleet use following command

```shell
sudo elastic-agent enroll -f --url=http://<ip-of-fleet>:8220 --enrollment-token=<enrollement-token-here> --insecure
```

```shell
sudo /bin/systemctl daemon-reload
```

```shell
sudo /bin/systemctl enable --now elastic-agent
```

## Uninstallation

Considering if you have installed Elastic Agent using RPM or repository, do following steps.

```shell
sudo yum remove elastic-agent -y
```

```shell
sudo find / -name 'elastic-agent'
```

```shell
sudo rm -rf /etc/elastic-agent/ /var/lib/elastic-agent/ /var/log/elastic-agent/ /usr/share/elastic-agent/
```

Make sure  `port 6789`  is not used by either Elastic-Agent or anyone else. 
Check using following command .

```shell
sudo netstat -tulpn
```

If the port is being used, restart the instance using either `init 6` , `shutdown -r now` or `reboot`.