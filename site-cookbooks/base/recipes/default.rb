include_recipe "apt"
include_recipe "git"
include_recipe "build-essential"
include_recipe "user"

# github
known_hosts = [
  '|1|Dd20I1RIliSs14slc2EJReQLxQY=|M/58zAEe0mrnf5cke7HqbxYc9Wk= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==',
  '|1|+sXobrUxR484VL5WD4TPCsldCHI=|7tWWhHBVaaS9BH2OmghavNXb0j8= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=='
]

directory "/root/.ssh" do
  recursive true
end

file "/root/.ssh/known_hosts" do
  content known_hosts.join("\n")
  mode 0644
end

# TODO Install the configuration files + ruby setup for the deploy user

['tmux', 'zsh', 'vim'].each do |pkg|
  package pkg == 'vim' ? 'vim-nox' : pkg

  git "#{Dir.home}/.#{pkg}" do
    repository "git://github.com/nviennot/#{pkg}-config.git"
    action :sync
    notifies :run, "bash[install_#{pkg}]", :immediately
  end

  bash "install_#{pkg}" do
    action :nothing
    cwd "#{Dir.home}/.#{pkg}"
    code "make install"
  end
end

['curl', 'sysstat', 'htop', 'iftop'].each do |pkg|
  package pkg
end
