require 'sinatra/base'

class LockrHttpServer < Sinatra::Base
  
  get '/' do
    # TODO add keyfile
    entries = settings.pwdmgr.list()
    erb :index, :locals => { :entries => entries }
  end
  
  # server config
  set :public_dir, 'resources/static'
  set :port, 32187
  set :views, 'resources/views'
  
  run! 
end