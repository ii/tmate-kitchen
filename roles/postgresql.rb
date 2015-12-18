name "postgresql"

run_list "recipe[postgresql::server]"

default_attributes postgresql: {
  version: '9.4',
  password: {
    postgres: 'postgres'
  },
  config: {
    listen_addresses: '0.0.0.0',
  },
}
