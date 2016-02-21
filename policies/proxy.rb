# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://github.com/opscode/chef-dk/blob/master/POLICYFILE_README.md

# A name that describes what the system you're building with Chef does.
name "tmate_proxy"

# Where to find external cookbooks:

# run_list: chef-client will run these recipes in the order specified.
run_list "hosts",
         "base",
         "time",
         "iptables",
         "ruby",
         "role[collectd_graphite]",
         "tmate_nginx",
         "tmate_proxy",
         "tmate_slave"

override['apache_auth']['htpasswd_file'] = '/etc/nginx-htpasswd'
override['apache_auth']['user'] = 'user'
override['apache_auth']['password'] = 'password'
override['graphite']['nginx_port'] = 80
override['graphite']['nginx_htpasswd'] = '/etc/nginx-htpasswd'

override['iptables']['services']['tmate'] = 22
override['iptables']['services']['ssh'] = 222
override['iptables']['services']['http'] = 80
override['iptables']['services']['https'] = 443

# Specify a custom source for a single cookbook:
# cookbook "example_cookbook", path: "../cookbooks/example_cookbook"
default_source :supermarket

cookbook 'ntp'
cookbook 'graphite',       :github => 'hw-cookbooks/graphite'
cookbook 'collectd',       :github => 'coderanger/chef-collectd'
cookbook 'statsd',         :github => 'hectcastro/chef-statsd'
cookbook 'rvm',            :github => 'fnichol/chef-rvm'
cookbook 'user',           :github => 'fnichol/chef-user'
# cookbook 'timezone_lwrp',  :github => 'dragonsmith/chef-timezone'
# https://github.com/dragonsmith/timezone_lwrp/pull/4/commits
cookbook 'timezone_lwrp',  github: 'hh/timezone_lwrp', branch: 'patch-1'
cookbook 'logrotate',      :github => 'opscode-cookbooks/logrotate'
cookbook 'nginx',          :github => 'miketheman/nginx'
cookbook 'memcached',      :github => 'opscode-cookbooks/memcached'
cookbook 'redis',          :github => 'miah/chef-redis'
cookbook 'postgresql',     :github => 'hw-cookbooks/postgresql'

cookbook 'base',              :path => '../site-cookbooks/base'
cookbook 'hosts',             :path => '../site-cookbooks/hosts'
cookbook 'collectd_graphite', :path => '../site-cookbooks/collectd_graphite'
cookbook 'graphite_all',      :path => '../site-cookbooks/graphite_all'
cookbook 'ruby',              :path => '../site-cookbooks/ruby'
cookbook 'apache_auth',       :path => '../site-cookbooks/apache_auth'
cookbook 'iptables',          :path => '../site-cookbooks/iptables'
cookbook 'time',              :path => '../site-cookbooks/time'
cookbook 'tmate_nginx',       :path => '../site-cookbooks/tmate_nginx'
cookbook 'tmate_slave',       :path => '../site-cookbooks/tmate_slave'
cookbook 'tmate_master',      :path => '../site-cookbooks/tmate_master'
cookbook 'tmate_proxy',       :path => '../site-cookbooks/tmate_proxy'

