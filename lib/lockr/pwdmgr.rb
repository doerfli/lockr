require 'lockr/encryption/aes'
require 'lockr/pwdstore'
require 'lockr/fileutils'
require 'rufus/scheduler'

class PasswordManager
  include Aes
  include LockrFileUtils
  
  def initialize( keyfile, vault)
    puts "Initializing Password manager module. Vault: '#{vault}', Keyfile: '...'"
    @vault = vault
    @keyfile = keyfile
    @scheduler = Rufus::Scheduler.new
  end
  
  def list()
    return get_vault()
  end
  
  def copy_password( id, username)
    vault = get_vault()
    
    Clipboard.copy vault[id][username].password
    puts 'Password copied to clipboard'
    
    if @job != nil
      @scheduler.unschedule( @job)
      puts 'Unscheduled old clear task' 
    end
    
    puts 'Scheduling clipboard reset in 15 seconds'
    @job = @scheduler.in '15s' do
      Clipboard.copy ' '
      puts 'Clipboard cleared'
    end
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