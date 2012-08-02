require 'openssl'
require 'highline/import'
require_relative 'action'
require_relative 'aespwdstore'


class BaseAction
  def calculate_hash( filename)
    sha1 = OpenSSL::Digest::SHA512.new

    File.open( filename) do |file|
      buffer = ''

      # Read the file 512 bytes at a time
      while not file.eof
        file.read(512, buffer)
        sha1.update(buffer)
      end
    end
    
    sha1.to_s
  end
  
  def save_to_vault( storelist, vault)
    rotate_vault( vault)
    
    File.open( vault, 'w') do |f|
      f.write( storelist.to_yaml)
    end
  end
  
  def rotate_vault( vault)
    return unless File.exists?(vault)
    
    # move old files first
    max_files = 2 # = 3 - 1
    max_files.downto( 0) { |i|
      
      if i == 0
        File.rename( vault, "#{vault}_#{i}")
      else
        j = i - 1
        if File.exists?("#{vault}_#{j}")
          File.rename( "#{vault}_#{j}", "#{vault}_#{i}")  
        end
      end
    }
  end
  
  def load_from_vault( vault)
    storelist = {} 
    
    if File.exist?( vault)
      File.open( vault, 'r') do |f|
        storelist = YAML::load(f)
      end
    end
    
    storelist
  end
end


class AddAction < BaseAction
  def initialize(id,url,username,pwd,keyfile,vault)
    keyfilehash = calculate_hash( keyfile)
    
    stores = load_from_vault( vault)
    unless stores.has_key?( id)
      stores[id] = {}
    end
    
    if ( stores[id].has_key?( username))
      overwrite = ask( "Password already exists. Overwrite? (y/n)  ") { |q| }
      unless overwrite.downcase == 'y'
        exit 14
      end
    end
    
    new_store = AesPasswordStore.new( id, url, username, pwd, keyfilehash)
    stores[id][username] = new_store
    
    save_to_vault( stores, vault)
    say("Password saved for ID '<%= color('#{id}', :blue) %>' and user '<%= color('#{username}', :blue) %>'")
  end
end


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


class RemoveAction < BaseAction
  def initialize(id,username,vault)
    stores = load_from_vault( vault)
    
    unless stores.has_key?( id)
      puts "Id '#{id}' not found"
      exit 20
    end
    
    unless stores[id].has_key?(username)
      puts "Username '#{username}' not found for id '#{id}'"
      exit 21
    end
    
    if ( stores[id].has_key?( username))
      overwrite = ask( "Are you sure you want to delete the entry with id '#{id}' and username '#{username}'? (y/n)  ") { |q| }
      unless overwrite.downcase == 'y'
        exit 22
      end
    end
    
    stores[id].delete( username)
    save_to_vault( stores, vault)
    puts "Entry removed"
  end
end
