require 'lockr/encryption/aes'
require 'lockr/pwdstore'
require 'lockr/fileutils'
require 'rufus/scheduler'

class PasswordManager
  include Aes
  include LockrFileUtils
  
  def initialize( keyfile, vault)
    puts "Initializing Password manager module. Vault: '#{vault}', Keyfile: '...'"
    @vault_file = vault
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
  
  def change_password( id, username, password)
    ###TODO better encryption code for vault
    LockrFileUtils.rotate_file( @vault_file, 3)
    keyfilehash = LockrFileUtils.calculate_sha512_hash( @keyfile)
    vault = load_from_vault( @vault_file)
    site_dir = YAML::load(decrypt( vault[id][:enc], keyfilehash, vault[id][:salt]))
    site_dir[username].password = password
    vault[id][:enc], vault[id][:salt] = encrypt( site_dir.to_yaml, keyfilehash)
    
    save_to_vault( vault, @vault_file)
    puts 'Change password and saved to vault'
  end
  
  def add( id, username, password)
    LockrFileUtils.rotate_file( @vault_file, 3)
    # ###TODO strange ... use getvault()
    keyfilehash = LockrFileUtils.calculate_sha512_hash( @keyfile)
    vault = load_from_vault( @vault_file)
    
    # get site directory
    if vault.has_key?( id)
      site_dir = YAML::load(decrypt( vault[id][:enc], keyfilehash, vault[id][:salt]))
    else
      site_dir = {}
    end
    
    # TODO add url
    new_store = PasswordStore.new( id, nil, username, password)
    site_dir[username] = new_store
    
    vault[id] = {}
    vault[id][:enc], vault[id][:salt] = encrypt( site_dir.to_yaml, keyfilehash)
    
    save_to_vault( vault, @vault_file)
    puts 'Added new id/username combination to vault'
  end
  
  def get_vault()
    pwd_directory = load_from_vault( @vault_file)
    keyfilehash = LockrFileUtils.calculate_sha512_hash( @keyfile)
    vault = {}
    
    pwd_directory.each { |id,value|
      vault[id] = YAML::load(decrypt( value[:enc], keyfilehash, value[:salt]))
    }
    
    return vault
  end
  
end