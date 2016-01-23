directory "#{node[:tmate_master][:app_path]}/running-config" do
  recursive true
end

# for edeliver and our failure to name our app properly
link "#{node[:tmate_master][:app_path]}/tmate" do
  to '.'
end

template "#{node[:tmate_master][:app_path]}/running-config/vm.args" do
  source 'vm.args.erb'
  owner 'root'
  mode '0644'
  variables :name   => "master@#{node[:hostname]}.tmate.io", # fqdn?
            :cookie => 'tmate'
end

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
