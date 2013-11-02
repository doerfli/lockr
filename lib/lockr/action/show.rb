require 'lockr/action/aes'

class ShowAction < AesAction
  
  def initialize(id,username,keyfile, vault)
    keyfilehash = LockrFileUtils.calculate_sha512_hash( keyfile)
    
    pwd_directory = load_from_vault( vault)
    
    unless pwd_directory.has_key?( id)
      puts "Id '#{id}' not found"
      exit 10
    end
    
    pwd_directory_id = YAML::load(decrypt( pwd_directory[id][:enc], keyfilehash, pwd_directory[id][:salt]))
    
    if username.nil? 
      if pwd_directory_id.length == 1
        key = pwd_directory_id.keys[0]
        store = pwd_directory_id[key]
      else
        puts "More than one username for id '#{id}'."
        while username.nil? 
          username = ask("Username?  ") { |q| }
          username = nil if username.strip == ''
        end
        store = pwd_directory_id[username]
      end
    else  
      unless pwd_directory_id.has_key?(username)
        puts "Username '#{username}' not found for id '#{id}'"
        exit 11
      end
      
      store = pwd_directory_id[username]
    end
    
    say("Password found")
    say("ID '<%= color('#{store.id}', :blue) %>', URL '<%= color('#{store.url}', :blue) %>'")
    say("User '<%= color('#{store.username}', :blue) %>'")
    say("Password:  <%= color('#{store.password}', :green) %>")
  end
  
end