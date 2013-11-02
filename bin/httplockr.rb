require 'lockr/http/httplockrinit'

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
  entries = settings.pwdmgr.list()
  erb :index, :locals => { :entries => entries }
end

