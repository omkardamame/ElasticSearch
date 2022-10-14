
## Prerequisite

#### 1. Setting up JVM

```shell
sudo yum install java-11-openjdk
```

#### 2. Save passwords, enrollment tokens, and service tokens

Remember to save the passwords, enrollment token, and service tokens while they get generated. You'll need them.

# 1. Install Elasticsearch with RPM

## 1.1 Import the Elasticsearch GPG Key

Download and install public signing key
```shell
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
```

## 1.2 Installing from RPM repository

Create a file called ```elasticsearch.repo``` in the ```/etc/yum.repos.d/``` directory for RedHat based distributions.
```
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
```

You can now install Elasticsearch with one of the following commands
```
sudo yum install --enablerepo=elasticsearch elasticsearch
```
or
```
sudo dnf install --enablerepo=elasticsearch elasticsearch
```

## 1.3 Configure ElasticSearch

```shell
vim /etc/elasticsearch/elasticsearch.yml
```

Add following lines for minimal security and basic configuration, save it.

```yaml
network.host: <ip-address>
discovery.type: single-node
```

## 1.4 Running Elasticsearch with ```systemd```

To configure Elasticsearch to start automatically when the system boots up, run the following commands:

```
sudo /bin/systemctl daemon-reload
```

```
sudo /bin/systemctl enable elasticsearch.service
```

Elasticsearch can be started and stopped as follows:
```
sudo systemctl start elasticsearch.service
```
```
sudo systemctl stop elasticsearch.service
```

To list journal entries for the elasticsearch service:
```
sudo journalctl -u elasticsearch.service
```


## 1.5 Check if Elasticsearch is running

```
curl http://<your-configured-ip>:9200
```

Ensure that you use ```http``` in your call, or the request will fail.

Enter the password for the ```elastic``` user that was generated during installation, which should return a response like this:
```
{
  "name" : "elastic.prodevans.lan",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "XDs0nV17QmWs1RQc0budxw",
  "version" : {
    "number" : "7.17.6",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "f65e9d338dc1d07b642e14a27f338990148ee5b6",
    "build_date" : "2022-08-23T11:08:48.893373482Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

## 1.6 Adding elasticsearch service to firewalld

```
firewall-cmd --permanent --add-service=elasticsearch
```

```
firewall-cmd --reload
```

## 1.7 Removing ElasticSearch

```
yum remove elasticsearch
```
```
rm -rf elasticsearch/ && rm -rf /etc/elasticsearch/ && rm -rf /usr/share/elasticsearch/
```

# 2. Install Kibana with RPM

## 2.1 Installing from the RPM repository:

Create a file called ```kibana.repo``` in the ```/etc/yum.repos.d/``` directory for RedHat based distributions:

```
[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
```

And your repository is ready for use. You can now install Kibana with one of the following commands:

```
sudo yum install kibana
```

## 2.2 Configuring Kibana

Go to

```
vim /etc/kibana/kibana.yml
```

Add these lines

```yaml
elasticsearch.username: "elastic"
elasticsearch.password: "<passwd>"
server.host: "<hostname>"
elasticsearch.hosts: ["http://<ip-address>:9200"]
```

## 2.3 Run Kibana with ```systemd```:

To configure Kibana to start automatically when the system starts, run the following commands:

```
sudo /bin/systemctl daemon-reload
```

```
sudo /bin/systemctl enable kibana.service
```

## 2.4 Adding Kibana to firewalld

```
firewall-cmd --permanent --add-service=kibana
```

```
firewall-cmd --reload
```


## 2.5 Kibana can be started and stopped as follows:

```
sudo systemctl start kibana.service
```
```
sudo systemctl stop kibana.service
```


# 3. Setting up minimal security

Add these lines to  `/etc/elasticsearch/elasticsearch.yml`

```
xpack.security.enabled: true
xpack.security.authc.api_key.enabled: true
```

Restart the ElasticSearch and reset all password using below command

```
/usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive
```




> References : 
>
> https://www.elastic.co/guide/en/elasticsearch/reference/7.17/rpm.html
> 
> https://www.elastic.co/guide/en/elasticsearch/reference/7.17/security-minimal-setup.html
> 
> https://www.elastic.co/downloads/past-releases/elastic-agent-7-17-6
> 
