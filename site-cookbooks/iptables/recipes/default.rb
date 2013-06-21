include_recipe 'simple_iptables'

simple_iptables_rule "connected" do
  rule "--match conntrack --ctstate ESTABLISHED,RELATED"
  jump "ACCEPT"
end

hosts = node[:iptables][:trusted_ips].dup
# Fall back to hosts definitions
hosts += node[:hosts].values
hosts << '127.0.0.1'

hosts.uniq.each do |ip|
  simple_iptables_rule "trusted_ips" do
    rule "--proto all --src #{ip}"
    jump "ACCEPT"
  end
end

node[:iptables][:services].each do |service, port|
  simple_iptables_rule service do
    rule "--proto tcp --dport #{port}"
    jump "ACCEPT"
  end
end

simple_iptables_rule 'ping' do
  rule "--proto icmp --icmp-type 8"
  jump "ACCEPT"
end

# The rest goes to /dev/null
simple_iptables_policy "INPUT" do
  policy "DROP"
end
