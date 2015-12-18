#!/usr/bin/env ruby
require 'json'
require 'optparse'
require './nodes/_definitions'

options = {}
op = OptionParser.new do |opts|
  opts.banner = "Usage: deploy.rb what node_name [options]"

  opts.on("-o", "--only REGEXP", "only") do |o|
    options[:only] = Regexp.new(o)
  end

  opts.on("-c", "--skip-common", "skip common") do
    options[:skip_common] = true
  end

  opts.on("-p", "--skip-prepare", "skip prepare") do
    options[:skip_prepare] = true
  end

  opts.on("-s", "--secret WHAT", "upload secret") do |what|
    options[:upload_secret] = what
  end
end
op.parse!

what = ARGV[0]
node = ARGV[1]
if ARGV.size != 2
  puts op.help
  exit
end

json_file = "nodes/#{node}.json"
node_def = NodeDefinitions.config_for(node, options)
node_ip = node_def['hosts'][node]
node_ssh_port = node_def[:ssh_port] || 22
File.write(json_file, JSON.pretty_generate(node_def))

cmd = []

cmd << "rsync -avzP -e 'ssh -p#{node_ssh_port}' ../tmate-#{what}/rel/tmate/releases/0.0.1/tmate.tar.gz root@#{node_ip}:/tmp/tmate-#{what}.tar.gz"

install_script = <<-SCRIPT
#!/bin/bash
set -e
cd /srv/tmate-#{what}
tar xf /tmp/tmate-#{what}.tar.gz
SCRIPT

cmd << "echo '#{install_script}' | ssh -p#{node_ssh_port} root@#{node_ip} bash -s"

exec(cmd.join(' && '))
