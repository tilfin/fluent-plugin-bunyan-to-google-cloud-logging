lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name    = "fluent-plugin-bunyan-to-google-cloud-logging"
  spec.version = "0.3.0"
  spec.authors = ["Toshimitsu Takahashi"]
  spec.email   = ["toshi@tilfin.com"]

  spec.summary       = %q{Fluentd plugin to transfer bunyan format logs to Google Cloud Logging}
  spec.description   = %q{Fluentd plugin to parse bunyan format logs and to transfer Google Cloud Logging.}
  spec.homepage      = "https://github.com/tilfin/fluent-plugin-bunyan-to-google-cloud-logging"
  spec.license       = "Apache-2.0"

  test_files, files  = `git ls-files -z`.split("\x0").partition do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.files         = files
  spec.executables   = files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = test_files
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "test-unit", "~> 3.0"
  spec.add_runtime_dependency "fluentd", [">= 0.14.10", "< 2"]
  spec.add_runtime_dependency "google-cloud-logging", "~> 1.5", ">= 1.5.1"
end
