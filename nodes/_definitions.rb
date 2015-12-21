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
        fk1: '46.101.184.80',
        sg1: '128.199.246.194',

        db:      "45.55.37.189",
        redis:   "45.55.37.189",
        master1: "45.55.37.189",
        ny2:     "104.236.9.236",
        am2:     "188.226.143.183",
        sf2:     "159.203.237.156",
        fk2:     "46.101.170.73",
        to2:     "159.203.36.122",
        sg2:     "188.166.217.223",
        ln2:     "46.101.84.153",
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

  # def shared_app
    # { run_list: ["recipe[ruby]",
                 # "role[collectd_graphite]",
                 # "recipe[tmate_nginx]",
                 # "recipe[tmate]"],
      # ssh_port: 222,
      # iptables: { services: { tmate: 22, ssh: 222, nginx: 80 } } }
  # end
  # %w(am1 sf1 ny1 sg1 fk1 ln1).each { |host| alias_method host, :shared_app }

  def master
    { run_list: ["role[collectd_graphite]",
                 "role[redis]",
                 "role[postgresql]",
                 "recipe[tmate_master]"],
      iptables: { services: { http: 80, https: 443 } } }
  end
  alias_method :master1, :master

  def proxy
    { run_list: ["recipe[ruby]",
                 "role[collectd_graphite]",
                 "recipe[tmate_nginx]",
                 "recipe[tmate_proxy]",
                 "recipe[tmate_slave]"],
      ssh_port: 222,
      iptables: { services: { tmate: 22, ssh: 222, http: 80, https: 443 } } }
  end
  %w(am2 sf2 ny2 sg2 fk2 ln2 to2).each { |host| alias_method host, :proxy }

  def config_for(node, options = {})
    config = common
    config[:run_list] = [] if options[:skip_common]
    config = Chef::Mixin::DeepMerge.merge(config, __send__(node))
    config[:run_list] = config[:run_list].grep(options[:only]) if options[:only]
    config[:set_fqdn] = node
    config
  end
end
