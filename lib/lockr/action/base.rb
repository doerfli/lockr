require 'openssl'
require 'lockr/encryption/aes'
require 'lockr/fileutils'

class BaseAction
  include FileUtils
  
  def save_to_vault( storelist, vault)
    FileUtils.store_obj_yaml( vault, storelist)
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
    FileUtils.load_obj_yaml( vault)
  end
end