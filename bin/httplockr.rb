#!/usr/bin/env ruby

require 'lockr/http/httplockrinit'
require 'erb'
require 'clipboard'  


include ERB::Util

init = HttpLockrInit.new()
init.start()

# now start sinatra
require 'sinatra'

set :pwdmgr, init.getPwdMgr()
# server config
set :public_dir, 'resources/static'
set :port, 32187
set :views, 'resources/views'
 
get '/' do
  dir = settings.pwdmgr.list()
  erb :index, :locals => { :directory => dir }
end

get '/password' do
  id = params[:id]
  username = params[:username]
  settings.pwdmgr.copy_to_clipboard( id, username)
  redirect '/'
end

post '/password' do
  id = params[:id]
  username = params[:username]
  password = params[:password]
  newPwdstore = settings.pwdmgr.add( id, username, password)
  dir = settings.pwdmgr.list()
  erb :index, :locals => { :directory => dir, :created => newPwdstore }
end

patch '/password' do
  id = params[:id]
  username = params[:username]
  password = params[:password]
  settings.pwdmgr.change( id, username, password)
  redirect '/'
end

delete '/password' do
  id = params[:id]
  username = params[:username]
  settings.pwdmgr.delete( id, username)
  redirect '/'
end

