require 'openssl'
require 'securerandom'

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