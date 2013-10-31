require 'sinatra/base'

class LockrHttpServer < Sinatra::Base
  get '/' do
    'Hello World'
  end
  
  run! 
end