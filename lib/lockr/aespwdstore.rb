require "securerandom"
require "openssl"
require "base64"
require_relative "pwdstore"

# The AesPasswordStore stored AES encrypted passwords. 
# The OpenSSL implementation for ruby is used to do the
# AES 256-bit encryption/decryption. 
class AesPasswordStore < BasePasswordStore
  
  private
    # encrypt the string with AES 256-bit CBC encryption. 
    # the key and iv are calculated by the derive_key_iv 
    # method using the provided password. 
    def encrypt( string, pass)
      key, iv = derive_key_iv( pass)
      
      cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      cipher.encrypt
      cipher.key = key
      cipher.iv = iv
      @enc_pwd = cipher.update(string) + cipher.final
    end
    
    # decrypt the string with AES 256-bit CBC encryption. 
    # the key and iv are calculated by the derive_key_iv 
    # method using the provided password. 
    def decrypt( string, pass)
      key, iv = derive_key_iv( pass)
      
      decipher = OpenSSL::Cipher::AES.new(256, :CBC)
      decipher.decrypt
      decipher.key = key
      decipher.iv = iv

      plain = decipher.update( string) + decipher.final
      plain
    end
    
    # derive a key and initial vector from the password thru
    # the use of PKCS5 pbkdf2 key derivation function. 
    # if no salt is stored yet in the instance, a 16-byte random 
    # salt is created and stored in the instance variable @salt 
    def derive_key_iv( pass)
      if @salt.nil?
        @salt = Base64.encode64( SecureRandom.random_bytes(16)).strip()
      end
      
      salt = Base64.decode64( @salt)
      key = OpenSSL::PKCS5::pbkdf2_hmac_sha1( pass, salt, 4096, 32)
      iv = OpenSSL::PKCS5::pbkdf2_hmac_sha1( pass, salt, 4096, 16)
      
      [key, iv]
    end
  
end
