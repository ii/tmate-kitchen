include_recipe "build-essential"
package "cmake"

libssh_src_dir = "/usr/src/libssh"
libssh_tar = "libssh-0.7.2.tar.xz"
libssh_url = "https://red.libssh.org/attachments/download/177/libssh-0.7.2.tar.xz"
libssh_sum = "a32c45b9674141cab4bde84ded7d53e931076c6b0f10b8fd627f3584faebae62"

directory libssh_src_dir do
  action :create
end

execute "install-libssh" do
  cwd libssh_src_dir
  command "mkdir -p build && cd build && cmake .. && make && make install"
  action :nothing
end

execute "libssh-extract-source" do
  command "tar xf #{Chef::Config.file_cache_path}/#{libssh_tar} --strip-components 1 -C #{libssh_src_dir}"
  creates "#{libssh_src_dir}/INSTALL"
  only_if do File.exist?("#{Chef::Config.file_cache_path}/#{libssh_tar}") end
  action :run
  notifies :run, "execute[install-libssh]", :immediately
end

remote_file "#{Chef::Config.file_cache_path}/#{libssh_tar}" do
  source libssh_url
  mode 0644
  checksum libssh_sum
  notifies :run, "execute[libssh-extract-source]", :immediately
end
