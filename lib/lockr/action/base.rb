require 'openssl'
require 'lockr/encryption/aes'
require 'lockr/fileutils'

class BaseAction
  include FileUtils
  
  def calculate_hash( filename)
    sha512 = OpenSSL::Digest::SHA512.new

    File.open( filename) do |file|
      buffer = ''

      # Read the file 512 bytes at a time
      while not file.eof
        file.read(512, buffer)
        sha512.update(buffer)
      end
    end
    
    sha512.to_s
  end
  
  def save_to_vault( storelist, vault)
    rotate_file( vault, 3)
    store_obj_yaml( vault, storelist)
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
    load_obj_yaml( vault)
  end
end