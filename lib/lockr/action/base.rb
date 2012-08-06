require 'openssl'
require 'lockr/encryption/aes'

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
  
  # loads the datastructure for the password sets from the file
  # it looks like this:
  #
  # pwd_directory = { 
  #   :id => { 
  #     :enc  => 'encrypted password store list', 
  #     :salt => 'salt for decryption' 
  #   } 
  # }
  #
  # decrypted_store_list = {
  #   :username => PasswordStore
  # }
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