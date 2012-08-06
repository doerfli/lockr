require 'openssl'
require 'securerandom'

module Aes
  # encrypt the string with AES 256-bit CBC encryption. 
  # the key and iv are calculated by the derive_key_iv 
  # method using the provided password. 
  #
  # returns encrypted_string, salt
  def encrypt( string, pass)
    salt = SecureRandom.random_bytes(16)
    key, iv = derive_key_iv( pass, salt)
    
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = key
    cipher.iv = iv
    [cipher.update(string) + cipher.final, salt]
  end
  
  # decrypt the string with AES 256-bit CBC encryption. 
  # the key and iv are calculated by the derive_key_iv 
  # method using the provided password. 
  def decrypt( string, pass, salt)
    key, iv = derive_key_iv( pass, salt)
    
    decipher = OpenSSL::Cipher::AES.new(256, :CBC)
    decipher.decrypt
    decipher.key = key
    decipher.iv = iv

    decipher.update( string) + decipher.final
  end
  
  # derive a key and initial vector from the password thru
  # the use of PKCS5 pbkdf2 key derivation function. 
  def derive_key_iv( pass, salt)
    key = OpenSSL::PKCS5::pbkdf2_hmac_sha1( pass, salt, 4096, 32)
    iv = OpenSSL::PKCS5::pbkdf2_hmac_sha1( pass, salt, 4096, 16)
    
    [key, iv]
  end
end