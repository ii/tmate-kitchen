#!/usr/bin/env ruby
require 'json'
require 'optparse'
require './nodes/_definitions'

options = {}
op = OptionParser.new do |opts|
  opts.banner = "Usage: deploy_erlang.rb node_name [options]"

  opts.on("-b", "--bootstrap", "bootstrap only") do
    options[:bootstrap] = true
  end

  opts.on("-v", "--version VERSION", "version") do |v|
    options[:version] = v
  end

  opts.on("-w", "--what WHAT", "what") do |what|
    options[:what] = what
  end
end
op.parse!

if ARGV.empty?
  puts op.help
  exit
end
node = ARGV[0]

json_file = "nodes/#{node}.json"
node_def = NodeDefinitions.config_for(node, options)
node_ip = node_def['hosts'][node]
node_ssh_port = node_def[:ssh_port] || 22
File.write(json_file, JSON.pretty_generate(node_def))

whats = []
whats << 'master' if node_def['run_list'].grep(/tmate_master/).any?
whats << 'proxy'  if node_def['run_list'].grep(/tmate_proxy/).any?

what = options[:what] || whats.first

versions = Dir["../tmate-#{what}/rel/tmate/releases/*.*.*"].map { |v| Gem::Version.new(v.split('/').last) }.sort
version = options[:version] || versions.last.to_s

cmd = []
run_script = nil

if options[:bootstrap]
  cmd << "rsync -avzP -e 'ssh -p#{node_ssh_port}' ../tmate-#{what}/rel/tmate/releases/#{version}/tmate.tar.gz root@#{node_ip}:/tmp/tmate-#{what}.tar.gz"

  run_script = <<-SCRIPT
  #!/bin/bash
  set -e
  cd /srv/tmate-#{what}
  tar xf /tmp/tmate-#{what}.tar.gz
  SCRIPT
else
  cmd << "rsync -avzP -e 'ssh -p#{node_ssh_port}' ../tmate-#{what}/rel/tmate/releases/#{version}/tmate.tar.gz root@#{node_ip}:/srv/tmate-#{what}/releases/#{version}/"

  run_script = <<-SCRIPT
  #!/bin/bash
  set -e
  cd /srv/tmate-#{what}
  bin/tmate upgrade #{version}
  SCRIPT
end

cmd << "echo '#{run_script}' | ssh -p#{node_ssh_port} root@#{node_ip} bash -s"

exec(cmd.join(' && '))
