include_attribute 'rvm'

default[:rvm][:gpg][:keyserver] = "hkp://keys.gnupg.net" # can remove eventually

default[:rvm][:rubies] = ['ruby-2.1']
default[:rvm][:default_ruby] = default[:rvm][:rubies].first
default[:rvm][:install_rubies] = true

default[:rvm][:global_gems] = [
  { 'name' => 'bundler' },
  { 'name' => 'rake' },
]

default[:rvm][:rvmrc] = {
  'rvm_project_rvmrc'             => 1,
  'rvm_gemset_create_on_use_flag' => 1,
  'rvm_trust_rvmrcs_flag'         => 1,
  'rvm_gem_options'               => '--no-ri --no-rdoc',
}
