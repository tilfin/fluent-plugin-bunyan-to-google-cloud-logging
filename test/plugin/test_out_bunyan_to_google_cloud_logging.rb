require "helper"
require "fluent/plugin/out_bunyan_to_google_cloud_logging.rb"

class BunyanToGoogleCloudLoggingOutputTest < Test::Unit::TestCase
  setup do
    Fluent::Test.setup
  end

  test "failure" do
    flunk
  end

  private

  def create_driver(conf)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::BunyanToGoogleCloudLoggingOutput).configure(conf)
  end
end
