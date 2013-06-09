ruby_block "Change SSH port" do
  block do
    file = Chef::Util::FileEdit.new("/etc/ssh/sshd_config")
    file.search_file_delete_line(/^Port [0-9]+$/)
    file.write_file # chef is dumb
    line = "Port #{node[:ssh_port]}"
    file.insert_line_if_no_match(/^#{line}$/, line)
    file.write_file
  end
end

# With vagrant, down/up
unless Dir.exists?('/home/vagrant')
  service "ssh" do
    action :restart
  end
end
