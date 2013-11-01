require 'sinatra/base'

class LockrHttpServer < Sinatra::Base
  get '/' do
    'Hello World'
  end
  
  # server config
  set :public_dir, 'resources/static'
  set :port, 32187
  
  run! 
end