require 'lockr/http/httplockrinit'
require 'erb'
require 'clipboard'  
require 'rufus/scheduler'

include ERB::Util

init = HttpLockrInit.new()
init.start()

scheduler = Rufus::Scheduler.new

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

get '/copypwd' do
  dir = settings.pwdmgr.list()
  id = params[:id]
  username = params[:username]
  pwd = Clipboard.copy dir[id][username].password
  puts 'Password copied to clipboard'
  
  scheduler.in '20s' do
    x = Clipboard.copy ' '
    puts 'Clipboard cleared'
  end

  redirect '/'
end
