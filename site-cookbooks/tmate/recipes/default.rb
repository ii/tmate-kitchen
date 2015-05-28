package "cmake"
package "pkg-config"
package "libtool"
package "libevent-dev"
package "libncurses-dev"
package "libssl-dev"
package "zlib1g-dev"

git node[:tmate][:app_path] do
  repository "https://github.com/nviennot/tmate-slave.git"
  action :sync
  notifies :run, "bash[compile tmate]", :immediately
  notifies :run, "bash[bundle monitor]", :immediately
end

bash "compile tmate" do
  cwd node[:tmate][:app_path]
  code "./autogen.sh && ./configure --enable-debug && make"
end

bash "bundle monitor" do
  #action :nothing
  cwd "#{node[:tmate][:app_path]}/monitor"
  code "/usr/local/rvm/bin/rvm-exec #{node[:tmate][:rvm_env]} bundle install"
end

directory node[:tmate][:log_path] do
  recursive true
end

template '/etc/init/tmate.conf' do
  source 'tmate.conf.erb'
  owner 'root'
  mode '0644'
  variables :app_path    => node[:tmate][:app_path],
            :log_path    => node[:tmate][:log_path],
            :keys_dir    => node[:tmate][:keys_dir],
            :listen_port => node[:tmate][:listen_port],
            :hostname    => "#{node[:hostname]}.#{node[:tmate][:domain]}"
end

service "tmate" do
  provider Chef::Provider::Service::Upstart
  action [:enable, :restart]
end

template '/etc/init/tmate-monitor.conf' do
  source 'tmate-monitor.conf.erb'
  owner 'root'
  mode '0644'
  variables :app_path => node[:tmate][:app_path],
            :rvm_env  => node[:tmate][:rvm_env]
end

service "tmate-monitor" do
  provider Chef::Provider::Service::Upstart
  action [:enable]
end

logrotate_app "tmate" do
  cookbook "logrotate"
  frequency "daily"
  path "#{node[:tmate][:log_path]}/tmate.log"
  postrotate "[ ! -f /var/run/tmate.pid ] || kill -USR1 `cat /var/run/tmate.pid`"
  rotate 300
end
