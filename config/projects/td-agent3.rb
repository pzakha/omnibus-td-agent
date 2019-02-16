require 'erb'
require 'fileutils'
require 'rubygems'

name "td-agent"
maintainer "Treasure Data, Inc"
homepage "http://treasuredata.com"
description "Treasure Agent: A data collector for Treasure Data"

if windows?
  install_dir "#{default_root}/opt/#{name}"
else
  install_dir "#{default_root}/#{name}"
end

# Custom Delphix version & revision
# build_version   "3.3.0"
# build_iteration 1
pkg_ver = ENV["PACKAGE_VERSION"]
pkg_rev = ENV["PACKAGE_REVISION"]
build_version "#{pkg_ver}"
build_iteration "#{pkg_rev}"

# creates required build directories
dependency "preparation"

override :ruby, :version => '2.4.5'
override :zlib, :version => '1.2.11'
override :jemalloc, :version => '4.5.0'
override :rubygems, :version => '2.6.14'
override :postgresql, :version => '9.6.9'
override :fluentd, :version => '5b80dd0d6256784963fe7b01181450268b481eb9' # v1.3.3

# td-agent dependencies/components
dependency "td-agent"
dependency "td-agent-files"
# comment below two, we don't need them
#dependency "td"
#dependency "td-agent-ui" # fluentd-ui doesn't work with ruby 2.4 because some gems depend on json 1.8
dependency "td-agent-cleanup"

# version manifest file
dependency "version-manifest"

# Add Delphix custom splunk-hec plugin
dependency "splunk-hec"

case ohai["os"]
when "linux"
  case ohai["platform_family"]
  when "debian"
    runtime_dependency "lsb-base"
  when "rhel", "amazon"
    runtime_dependency "initscripts"
    if ohai["platform_version"][0] == "5"
      runtime_dependency "redhat-lsb"
    else
      runtime_dependency "redhat-lsb-core"
    end
  end
end

exclude "\.git*"
exclude "bundler\/git"

compress :dmg do
end

package :msi do
  upgrade_code "76dcb0b2-81ad-4a07-bf3b-1db567594171"
end
