#!/usr/bin/env ruby
require 'json'
require 'optparse'
require './nodes/_definitions'

options = {}
op = OptionParser.new do |opts|
  opts.banner = "Usage: deploy.rb what node_name [options]"
end
op.parse!

whats = ARGV[0]
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

whats.split(',').each do |what|
  src, dst = case what
    when 'ssh' then ['ssh/*', '/etc/ssh/tmate-keys']
    when 'ssl' then ['ssl/*', '/etc/ssl/private']
  end

  cmd << "rsync -avzP -e 'ssh -p#{node_ssh_port}' secret_files/#{src} root@#{node_ip}:#{dst}"
  cmd << "ssh -p#{node_ssh_port} root@#{node_ip} chown -R root: #{dst}"
  cmd << "ssh -p#{node_ssh_port} root@#{node_ip} chmod 700 #{dst}"
end

exec(cmd.join(' && '))
