# Filebeat Installtion and Configuration 

## Download the Appropriate RPM Package:

Your Elasticsearch version should match with the version of Filebeat.

```shell
curl -O -L https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.5.0-x86_64.rpm
```
instead of curl you can use wget as well if you want,

After Installation you have to open `/etc/filebeat/filebeat.yml` file for configuration.
```yaml
###################### Filebeat Configuration Example #########################
# ============================== Filebeat inputs ===============================

filebeat.inputs:

# Each - is an input. Most options can be set at the input level, so
# you can use different inputs for various configurations.
# Below are the input specific configurations.

# filestream is an input for collecting log messages from files.
- type: filestream

  # Unique ID among all inputs, an ID is required.
  id: el1-filestream

  # Change to true to enable this input configuration.
  enabled: false

  # Paths that should be crawled and fetched. Glob based paths.
  paths:
    - /var/log/*.log
    #- c:\programdata\elasticsearch\logs\*

# ============================== Filebeat modules ==============================

filebeat.config.modules:
  # Glob pattern for configuration loading
  path: ${path.config}/modules.d/*.yml

  # Set to true to enable config reloading
  reload.enabled: false

  # Period on which files under path should be checked for changes
  #reload.period: 10s

# ======================= Elasticsearch template setting =======================

setup.template.settings:
  index.number_of_shards: 1
  #index.codec: best_compression
  #_source.enabled: false
# =================================== Kibana ===================================

# Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API.
# This requires a Kibana endpoint configuration.
setup.kibana:
  host: "192.168.1.220:5601"
  username: "yourusername"
  password: "yourpassword"
  protocol: "https" #you can comment this if its in http protocol
  ssl.verification_mode: "none"

  # Kibana Host
  # Scheme and port can be left out and will be set to the default (http and 5601)
  # In case you specify and additional path, the scheme is required: http://localhost:5601/path
  # IPv6 addresses should always be defined as: https://[2001:db8::1]:5601
  #host: "localhost:5601"

  # Kibana Space ID
  # ID of the Kibana Space into which the dashboards should be loaded. By default,
  # the Default Space will be used.
  #space.id:

# ================================== Outputs ===================================

# Configure what output to use when sending the data collected by the beat.

# ---------------------------- Elasticsearch Output ----------------------------
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["192.168.1.221:9200"]
  # Protocol - either `http` (default) or `https`.
  # Authentication credentials - either API key or username/password.
  #api_key: "id:api_key"
  username: "yourusername"
  password: "yourpassword"
  # Protocol - either `http` (default) or `https`.
  protocol: "https" #you can comment this if its in http protocol
  ssl.certificate_authorities: ["/etc/elasticsearch/certs/http_ca.crt"]
  # you can recyle the certificates of Elasticsearch here as well.

  # Authentication credentials - either API key or username/password.
  #api_key: "id:api_key"
  #username: "elastic"
  #password: "changeme"


# ================================= Processors =================================
processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~


```

A example Configuration File can be found on the website : https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-reference-yml.html

Now you have to Enable the modules that you want to monitor, For example :
```shell
filebeat modules enable system
```

If you are on the Elasticsearch Server you can monitor elasticsearch as well using the same command, but instead of system you need to write elasticsearch :
```shell
filebeat modules enable elasticsearch
```

If you want list of Modules that are available in filebeat then use,
```shell
filebeat modules list
```

After enabling the modules, their Config files will be located inside,
```shell
/etc/filebeat/modules.d/"module_name.yml"
```

you have to edit them according to your needs, For Example `system.yml` 
```shell
# Module: system
# Docs: https://www.elastic.co/guide/en/beats/filebeat/main/filebeat-module-system.html

- module: system
  # Syslog
  syslog:
    enabled: true

    # Set custom paths for the log files. If left empty,
    # Filebeat will choose the paths depending on your OS.
    #var.paths:

  # Authorization logs
  auth:
    enabled: true

    # Set custom paths for the log files. If left empty,
    # Filebeat will choose the paths depending on your OS.
    #var.paths:

```

After this you need to setup Filebeat and load its Dashboards into Kibana using,
```shell
filebeat setup -e
```

This is it, Now you should be able to see your dashboards in to Kibana after successful setup.