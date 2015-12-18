name "redis"

run_list "recipe[redis::server]"

default_attributes redis: {
  install_type: 'source',
  source: {
    sha:     "4c176826eee909fbdc63db1c15adc22aab42d758043829e556f4331e6a5bd480",
    url:     "http://download.redis.io/releases",
    version: "3.0.5"
  },

  symlink_binaries: true,
  config: {
    logfile: '/var/log/redis.log',
    bind: '0.0.0.0',
    dir: '/srv/redis',
    pidfile: '/srv/redis/redis.pid',
    timeout: 0,
  }
}
