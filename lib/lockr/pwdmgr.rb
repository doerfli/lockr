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
    return get_vault()
  end
  
  def get_vault()
    pwd_directory = load_from_vault( @vault)
    keyfilehash = LockrFileUtils.calculate_sha512_hash( @keyfile)
    vault = {}
    
    pwd_directory.each { |id,value|
      vault[id] = YAML::load(decrypt( value[:enc], keyfilehash, value[:salt]))
    }
    
    return vault
  end
  
end