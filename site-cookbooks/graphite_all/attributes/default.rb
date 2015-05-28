include_attribute "graphite"
include_attribute "nginx"
include_attribute "statsd"
include_attribute "memcached"

default[:graphite][:version] = '0.9.13'

default[:graphite][:nginx_port] = 80
default[:graphite][:nginx_htpasswd] = nil

default[:nginx][:user] = 'graphite'
default[:nginx][:group] = 'graphite'

default[:statsd][:flush_interval] = 10000
default[:statsd][:nodejs_bin] = '/usr/bin/node'

default[:memcached][:memory] = 256
default[:memcached][:listen] = '127.0.0.1'
