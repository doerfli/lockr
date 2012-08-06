require 'openssl'
require 'highline/import'
require_relative 'action'
require_relative 'aespwdstore'








class ShowAction < BaseAction
  def initialize(id,username,keyfile, vault)
    keyfilehash = calculate_hash( keyfile)
    
    stores = load_from_vault( vault)
    unless stores.has_key?( id)
      puts "Id '#{id}' not found"
      exit 10
    end
    
    if username.nil? 
      unless stores[id].length == 1
        puts "More than one username for id '#{id}'. Please provide a username!"
        exit 13
      end
       
      key = stores[id].keys[0]
      store = stores[id][key]
    else  
      unless stores[id].has_key?(username)
        puts "Username '#{username}' not found for id '#{id}'"
        exit 11
      end
      
      store = stores[id][username]
    end
    
    begin
      say("Password found")
      say("ID '<%= color('#{store.id}', :blue) %>', URL '<%= color('#{store.url}', :blue) %>'")
      say("User '<%= color('#{store.username}', :blue) %>'")
      say("Password:  <%= color('#{store.get_password( keyfilehash)}', :green) %>")
    rescue OpenSSL::Cipher::CipherError
      say( "<%= color('Invalid keyfile', :red) %>")
      exit 12
    end
  end
end


class ListAction < BaseAction
  def initialize(vault)
    stores = load_from_vault( vault)
    
    stores.each { |id,value|
      value.each { |username, store|
        puts "Id: #{id} / Username: #{username}"
      } 
    }
  end
end    



