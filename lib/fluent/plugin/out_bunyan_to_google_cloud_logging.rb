#
# Copyright 2018- Toshimitsu Takahashi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "fluent/plugin/output"
require "google/cloud/logging"

module Fluent::Plugin
  class BunyanToGoogleCloudLoggingOutput < Fluent::Plugin::Output
    Fluent::Plugin.register_output("bunyan_to_google_cloud_logging", self)

    config_param :project_id, :string
    config_param :keyfile, :string

    def start
      super

      Google::Cloud.configure do |config|
        config.project_id = @project_id
        config.keyfile = @keyfile
      end

      @logging = Google::Cloud::Logging.new
    end

    def process(tag, es)
      entries = []

      es.each do |time, record|
        msg = record.delete("msg")
        record["message"] = msg if msg

        entry = @logging.entry
        entry.log_name = tag

        labels = {}.tap do |h|
          app_name =  record.delete("name")
          h["app_name"] = app_name unless app_name.nil?

          hostname = record.delete("hostname")
          h["hostname"] = hostname unless hostname.nil?

          pid = record.delete("pid")
          h["pid"] = pid.to_s unless pid.nil?

          v = record.delete("v")
          h["log_version"] = v.to_s unless v.nil?
        end
        entry.labels = labels unless labels.empty?

        entry.resource.type = "global"
        if time.is_a?(Numeric)
          entry.timestamp = Time.at(time)
        else
          entry.timestamp = Time.at(time.sec, time.nsec, :nsec)
        end
        entry.severity = severity(record["level"])
        entry.payload = record
        entries << entry
      end

      @logging.write_entries entries
    end

    private

    def severity(level)
      case level
      when 10, 20
        :DEBUG
      when 30
        :INFO
      when 40
        :WARNING
      when 50
        :ERROR
      when 60
        :CRITICAL
      else
        :DEFAULT
      end
    end
  end
end
