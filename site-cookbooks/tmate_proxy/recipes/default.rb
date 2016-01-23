directory "#{node[:tmate_proxy][:app_path]}/running-config" do
  recursive true
end

# for edeliver and our failure to name our app properly
link "#{node[:tmate_proxy][:app_path]}/tmate" do
  to '.'
end

template "#{node[:tmate_proxy][:app_path]}/running-config/vm.args" do
  source 'vm.args.erb'
  owner 'root'
  mode '0644'
  variables :name   => "proxy@#{node[:hostname]}.tmate.io", # fqdn?
            :cookie => 'tmate'
end

template '/etc/init/tmate-proxy.conf' do
  source 'tmate-proxy.conf.erb'
  owner 'root'
  mode '0644'
  variables :app_path => node[:tmate_proxy][:app_path]
end

service "tmate-proxy" do
  provider Chef::Provider::Service::Upstart
  action [:enable]
end

