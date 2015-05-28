require 'chef/mash'
require 'chef/mixin/deep_merge'

module NodeDefinitions
  extend self
  def common
    {
      run_list: [
        "recipe[hosts]",
        "recipe[base]",
        "recipe[time]",
        "recipe[iptables]",
      ],

      hosts: {
        # these are trusted in iptables
        monitor: "45.55.187.84",
        sf1: '107.170.226.142',
        ny1: '104.131.19.169',
        ln1: '178.62.62.167',
        am1: '128.199.33.62',
        fk1: '46.101.184.80',
        sg1: '128.199.246.194',
      },
    }
  end

  def monitor
    { run_list: [ "recipe[apache_auth]",
                  "recipe[graphite_all]" ],
      apache_auth: [{
        htpasswd_file: '/etc/nginx-htpasswd',
        user: 'user',
        password: 'password' }],
      graphite: {
        nginx_port: 80,
        nginx_htpasswd: '/etc/nginx-htpasswd' },
      iptables: { services: { ssh: 22, nginx: 80 } } }
  end

  def shared_app
    { run_list: ["recipe[ruby]",
                 "role[collectd_graphite]",
                 "recipe[tmate_nginx]",
                 "recipe[tmate]"],
      ssh_port: 222,
      iptables: { services: { tmate: 22, ssh: 222, nginx: 80 } } }
  end
  %w(am1 sf1 ny1 sg1 fk1 ln1).each { |host| alias_method host, :shared_app }

  def config_for(node, options = {})
    config = common
    config[:run_list] = [] if options[:skip_common]
    config = Chef::Mixin::DeepMerge.merge(config, __send__(node))
    config[:run_list] = config[:run_list].grep(options[:only]) if options[:only]
    config[:set_fqdn] = node
    config
  end
end
