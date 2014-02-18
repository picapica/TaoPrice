# We're using RVM on a server, need this.
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '2.1.0'
set :rvm_type, :user

# Bundler tasks
require 'bundler/capistrano'

set :application, "TaoPrice"
set :repository,  "git://github.com/picapica/TaoPrice.git"

set :scm, :git

# do not use sudo
set :use_sudo, false
set(:run_method) { use_sudo ? :sudo : :run }

# This is needed to correctly handle sudo password prompt
default_run_options[:pty] = true

set :user, "lax"
set :group, user
set :runner, user

set :host, "#{user}@matrix.liulantao.com" # We need to be able to SSH to that box as this user.
role :web, host
role :app, host
role :db, host

set :deploy_to, "/home/lax/srv/#{application}"

set :default_environment, {
  'DATABASE_URL' => "sqlite:#{deploy_to}/shared/#{application}.sqlite"
}
require 'puma/capistrano'

before "deploy:create_symlink", "deploy:setup"

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end
after "deploy", "rvm:trust_rvmrc"