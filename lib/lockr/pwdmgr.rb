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
    return decrypt_vault()
  end
  
  def copy_password( id, username)
    vault = decrypt_vault()
    
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
    vault = decrypt_vault()
    site_dir = vault[id]
    site_dir[username].password = password
    
    encrypt_vault( vault)
    puts 'Change password and saved to vault'
  end
  
  def add( id, username, password)
    vault = decrypt_vault()
    site_dir = {}
    
    # get site directory
    if vault.has_key?( id)
      site_dir = vault[id]
    end
    
    # TODO add url
    new_store = PasswordStore.new( id, nil, username, password)
    site_dir[username] = new_store
    vault[id] = site_dir
    
    encrypt_vault( vault)
    puts 'Added new id/username combination to vault'
  end
  
  def decrypt_vault()
    pwd_directory = load_from_vault( @vault_file)
    keyfilehash = LockrFileUtils.calculate_sha512_hash( @keyfile)
    vault = {}
    
    pwd_directory.each { |id,site_dir_enc|
      vault[id] = YAML::load(decrypt( site_dir_enc[:enc], keyfilehash, site_dir_enc[:salt]))
    }
    
    return vault
  end
  
  def encrypt_vault( vault)
    LockrFileUtils.rotate_file( @vault_file, 3)
    keyfilehash = LockrFileUtils.calculate_sha512_hash( @keyfile)
    
    pwd_directory = {}
    
    vault.each { |id, site_dir_dec|
      pwd_directory[id] = {}
      pwd_directory[id][:enc], pwd_directory[id][:salt] = encrypt( site_dir_dec.to_yaml, keyfilehash)  
    }    

    save_to_vault( pwd_directory, @vault_file)
    puts 'Vault saved'
  end
  
end