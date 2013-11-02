require 'lockr/encryption/aes'
require 'lockr/pwdstore'
require 'lockr/fileutils'

class PasswordManager
  include Aes
  include LockrFileUtils
  
  def initialize( keyfile, vault)
    puts "Initializing Password manager module. Vault: '#{vault}', Keyfile: '...'"
    @vault = vault
    @keyfile = keyfile
  end
  
  def list()
    pwd_directory = load_from_vault( @vault)
    out = []
    
    pwd_directory.each { |id,value|
      out << id
    }
    
    out.sort!
    return out
  end
  
end