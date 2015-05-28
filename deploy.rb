#!/usr/bin/env ruby
require 'json'
require 'optparse'
require './nodes/_definitions'

options = {}
op = OptionParser.new do |opts|
  opts.banner = "Usage: deploy.rb node_name [options]"

  opts.on("-o", "--only REGEXP", "only") do |o|
    options[:only] = Regexp.new(o)
  end

  opts.on("-c", "--skip-common", "skip common") do
    options[:skip_common] = true
  end

  opts.on("-p", "--skip-prepare", "skip prepare") do
    options[:skip_prepare] = true
  end
end
op.parse!

node = ARGV[0]
if ARGV.empty?
  puts op.help
  exit
end

json_file = "nodes/#{node}.json"
node_def = NodeDefinitions.config_for(node, options)
node_ip = node_def['hosts'][node]
node_ssh_port = node_def[:ssh_port] || 22
File.write(json_file, JSON.pretty_generate(node_def))

cmd = []
unless options[:skip_prepare]
  cmd << "rm -rf cookbooks"
  cmd << "berks vendor cookbooks"
end
cmd << "knife solo cook -p#{node_ssh_port} --provisioning-path /root/chef-solo root@#{node_ip} #{json_file}"
exec(cmd.join(' && '))
