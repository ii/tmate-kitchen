include_recipe 'nginx::default'

template "/etc/nginx/sites-available/tmate" do
  source "tmate.erb"
end

nginx_site "default" do
  enable false
end

nginx_site "tmate" do
  enable true
end
