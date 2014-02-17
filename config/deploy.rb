# We're using RVM on a server, need this.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
# require 'rvm/capistrano'
set :rvm_ruby_string, '2.0.0'
# set :rvm_type, :user

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
role :db, host

set :rails_env, :production

# Where will it be located on a server?
set :deploy_to, "/home/lax/srv/#{application}"
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
set :database_url, "#{deploy_to}/shared/#{application}.sqlite"

# Unicorn control tasks
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && DATABASE_URL=#{database_url} bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "cd #{deploy_to}/current && DATABASE_URL=#{database_url} bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end