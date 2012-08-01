require 'openssl'
require 'base64'
    
# A password store contains an id of the site the password belongs to, 
# the username to login and the encrypted password. the decrypted password
# can be retrieved via the get_password method. 
# The BasePasswordStore contains no encryption or decryption logic. 
# This must be implemented in subclasses by implementing encrypt and 
# decrypt methods. 
    
class BasePasswordStore
    attr_accessor :id,:username,:enc_password
    
    # stores the id, username in the store. the given password is 
    # encrypted with the help of the encrypt method which is called 
    # with the password and the key. The encrypted password is then
    # stored in Base64 encoded form. 
    def initialize(id,username,pwd,key)
      @id = id
      @username = username
      @enc_pwd = Base64.encode64( encrypt( pwd, key)).strip()
    end
    
    # retrieve the decrypted password using the given decryption key.
    # before calling decrypt, the base64 encoded key is decoded. 
    def get_password( key)
      decrypt( Base64.decode64( @enc_pwd), key)
    end
  
  private  
    def encrypt( string, key)
      raise RuntimeError, "not implemented"
    end
    
    def decrypt( string, key)
      raise RuntimeError, "not implemented"
    end
end