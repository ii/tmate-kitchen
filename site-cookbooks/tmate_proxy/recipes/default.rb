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

