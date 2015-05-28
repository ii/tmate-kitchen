name "graphite"
run_list "recipe[graphite]",
         "recipe[graphite::carbon]",
         "recipe[graphite::web]",
         "recipe[graphite::uwsgi]",
         "recipe[statsd]"

default_attributes iptables: {
  services: { graphite_http: 80 }
}, graphite: {
  version: '0.9.13',
  uwsgi: { port: 80 },
  # timezone: 'America/New_York',
  # storage_schemas: [{ name: 'catchall',
                      # pattern: '^.*',
                      # retentions: '10s:30d,1m:120d,1h:1y' }]
}, statsd: {
  flush_interval: 10000,
  nodejs_bin: '/usr/bin/node'
}

# default['graphite']['graph_templates'] = [
  # {
    # 'name' => 'default',
    # 'background' => 'black',
    # 'foreground' => 'white',
    # 'majorLine' => 'white',
    # 'minorLine' => 'grey',
    # 'lineColors' => 'blue,green,red,purple,brown,yellow,aqua,grey,magenta,pink,gold,rose',
    # 'fontName' => 'Sans',
    # 'fontSize' => '10',
    # 'fontBold' => 'False',
    # 'fontItalic' => 'False'
  # }
# ]
