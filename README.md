# fluent-plugin-bunyan-to-google-cloud-logging

[![Gem Version](https://badge.fury.io/rb/fluent-plugin-bunyan-to-google-cloud-logging.svg)](https://badge.fury.io/rb/fluent-plugin-bunyan-to-google-cloud-logging)

[Fluentd](https://www.fluentd.org/) plugin to parse [bunyan](https://www.npmjs.com/package/bunyan) format logs and to transfer Google Cloud Logging.

## Installation

### RubyGems

```
$ gem install fluent-plugin-bunyan-to-google-cloud-logging
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-bunyan-to-google-cloud-logging"
```

And then execute:

```
$ bundle
```

## Configuration

### Example 1. Tailing a log file and transfering to Google Cloud Logging

```
<source>
  @type tail
  path /tmp/myapp.log
  pos_file /tmp/myapp.log.pos
  tag myapp.trace
  <parse>
    @type json
    time_key time
    time_format %FT%T.%L%z
  </parse>
</source>

<match **>
  @type bunyan_to_google_cloud_logging
  project_id  'my-project-211117'
  keyfile /etc/td-agent/secret/keyfile.json
</match>
```

### Example 2. Receiving docker container logs and transfering to Google Cloud Logging

#### /etc/td-agent/td-agent.conf

```
<source>
  @type forward
</source>

<filter docker.**>
  @type parser
  format json
  key_name log
  time_key time
  time_format %FT%T.%L%z
  reserve_data yes
</filter>

<filter docker.**>
  @type record_transformer
  remove_keys log
  <record>
    time ${time}
  </record>
</filter>

<match docker.**>
  @type bunyan_to_google_cloud_logging
  project_id  'high-office-001'
  keyfile /etc/td-agent/secret/gcp-key.json
</match>

<label @ERROR>
  <match **>
    @type bunyan_to_google_cloud_logging
    project_id  'high-office-001'
    keyfile /etc/td-agent/secret/gcp-key.json
  </match>
</label>
```

#### docker-compose.yml 

```
version: '3'
services:
  yourwebapp:
    image: registry.example.com/yourwebapp
    logging:
      driver: fluentd
      options:
        fluentd-address: "localhost:24224"
        tag: "docker.webapp"
    environment:
      NODE_ENV: production
    ports:
      - 8080:8080
```

## Fluent::Plugin::BunyanToGoogleCloudLoggingOutput

### project_id (string) (required)

your Project ID on Google Cloud Platform

### keyfile (string) (required)

Specify the path of key json file
https://cloud.google.com/iam/docs/creating-managing-service-account-keys

## Copyright

* Copyright(c) 2018- Toshimitsu Takahashi
* License
  * Apache License, Version 2.0
