package "cmake"
package "pkg-config"
package "libtool"
package "libevent-dev"
package "libncurses-dev"
package "libssl-dev"
package "zlib1g-dev"

include_recipe "tmate_slave::msgpack"
include_recipe "tmate_slave::libssh"

git node[:tmate_slave][:app_path] do
  repository "https://github.com/tmate-io/tmate-slave.git"
  revision 'master'
  action :sync
  notifies :run, "bash[compile tmate]", :immediately
  notifies :run, "bash[bundle monitor]", :immediately
end

bash "compile tmate" do
  cwd node[:tmate_slave][:app_path]
  code "./autogen.sh && ./configure --enable-debug && make"
  action :nothing
end

bash "bundle monitor" do
  cwd "#{node[:tmate_slave][:app_path]}/monitor"
  code "/usr/local/rvm/bin/rvm-exec #{node[:tmate_slave][:rvm_env]} bundle install"
  action :nothing
end

template '/etc/init/tmate-slave.conf' do
  source 'tmate-slave.conf.erb'
  owner 'root'
  mode '0644'
  variables :app_path    => node[:tmate_slave][:app_path],
            :log_path    => node[:tmate_slave][:log_path],
            :keys_dir    => node[:tmate_slave][:keys_dir],
            :listen_port => node[:tmate_slave][:listen_port],
            :hostname    => "#{node[:hostname]}.#{node[:tmate_slave][:domain]}"
end

service "tmate-slave" do
  provider Chef::Provider::Service::Upstart
  action [:enable]
end

template '/etc/init/tmate-monitor.conf' do
  source 'tmate-monitor.conf.erb'
  owner 'root'
  mode '0644'
  variables :app_path => node[:tmate_slave][:app_path],
            :rvm_env  => node[:tmate_slave][:rvm_env]
end

service "tmate-monitor" do
  provider Chef::Provider::Service::Upstart
  action [:enable]
end
