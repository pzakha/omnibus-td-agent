name "splunk-hec"
default_version 'insight'

dependency "ruby"

# customized hec plugin
source :git => 'https://github.com/delphix/fluent-plugin-splunk-hec.git'

build do
  env = with_standard_compiler_flags(with_embedded_path)

  gem "build fluent-plugin-splunk-hec.gemspec", env: env
  gem "install --no-ri --no-rdoc fluent-plugin-splunk-hec*.gem", env: env
end
