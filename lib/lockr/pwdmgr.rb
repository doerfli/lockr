require 'lockr/encryption/aes'
require 'lockr/pwdstore'
require 'lockr/fileutils'

class PasswordManager
  include Aes
  include LockrFileUtils
  
  def initialize( keyfile, vault)
    @vault = vault
    @keyfile = keyfile
  end
  
  def list()
    puts @vault
    pwd_directory = load_from_vault( @vault)
    puts pwd_directory
    out = []
    
    pwd_directory.each { |id,value|
      puts id
      out << id
    }
    
    out.sort!
    return out
  end
  
end