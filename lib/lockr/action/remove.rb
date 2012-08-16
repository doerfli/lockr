require 'lockr/action/aes'
require 'lockr/pwdstore'

class RemoveAction < AesAction
  
  def initialize(id,username,keyfile,vault)
    keyfilehash = calculate_sha512_hash( keyfile)
    pwd_directory = load_from_vault( vault)
    
    unless pwd_directory.has_key?( id)
      puts "Id '#{id}' not found"
      exit 20
    end
    
    pwd_directory_id = YAML::load(decrypt( pwd_directory[id][:enc], keyfilehash, pwd_directory[id][:salt]))
    
    unless pwd_directory_id.has_key?(username)
      puts "Username '#{username}' not found for id '#{id}'"
      exit 21
    end
    
    confirm = ask( "Are you sure you want to delete the entry with id '#{id}' and username '#{username}'? (y/n)  ") { |q| }
    unless confirm.downcase == 'y'
      exit 22
    end
    
    pwd_directory_id.delete( username)
    
    if ( pwd_directory_id.size == 0 )
      pwd_directory.delete( id)
    else
      pwd_directory[id] = {}
      pwd_directory[id][:enc], pwd_directory[id][:salt] = encrypt( pwd_directory_id.to_yaml, keyfilehash)
    end
    
    save_to_vault( pwd_directory, vault)
    puts "Entry removed"
  end
  
end