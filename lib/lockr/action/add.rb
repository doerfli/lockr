require 'lockr/action/base'

class AddAction < BaseAction
  
  def initialize(id,url,username,pwd,keyfile,vault)
    keyfilehash = LockrFileUtils.calculate_sha512_hash( keyfile)
    
    pwd_directory = load_from_vault( vault)
    
    if pwd_directory.has_key?( id)
      pwd_directory_id = YAML::load(decrypt( pwd_directory[id][:enc], keyfilehash, pwd_directory[id][:salt]))
    else
      pwd_directory_id = {}
    end
    
    if ( pwd_directory_id.has_key?( username))
      overwrite = ask( "Password already exists. Update? (y/n)  ") { |q| }
      unless overwrite.downcase == 'y'
        exit 14
      end
    end
    
    new_store = PasswordStore.new( id, url, username, pwd)
    pwd_directory_id[username] = new_store
    
    pwd_directory[id] = {}
    pwd_directory[id][:enc], pwd_directory[id][:salt] = encrypt( pwd_directory_id.to_yaml, keyfilehash)
    
    save_to_vault( pwd_directory, vault)
    say("Password saved for ID '<%= color('#{id}', :blue) %>' and user '<%= color('#{username}', :green) %>'")
  end
  
end