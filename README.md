# fluent-plugin-bunyan-to-google-cloud-logging

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
