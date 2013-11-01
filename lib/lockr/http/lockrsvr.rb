require 'sinatra/base'

class LockrHttpServer < Sinatra::Base
  get '/' do
    erb :index
  end
  
  # server config
  set :public_dir, 'resources/static'
  set :port, 32187
  set :views, 'resources/views'
  
  run! 
end