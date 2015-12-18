template '/etc/init/tmate-master.conf' do
  source 'tmate-master.conf.erb'
  owner 'root'
  mode '0644'
  variables :app_path => node[:tmate_master][:app_path]
end

service "tmate-master" do
  provider Chef::Provider::Service::Upstart
  action [:enable]
end

