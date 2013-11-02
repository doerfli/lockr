require 'sinatra/base'
require 'lockr/pwdmgr'

class LockrHttpServer < Sinatra::Base
  
  get '/' do
    # TODO add keyfile
    mgr = PasswordManager.new( nil, '/Users/moo/Documents/lockr/vault.yaml')
    entries = mgr.list()
    erb :index, :locals => { :entries => entries }
  end
  
  # server config
  set :public_dir, 'resources/static'
  set :port, 32187
  set :views, 'resources/views'
  
  run! 
end