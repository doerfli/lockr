require 'yaml'

module LockrFileUtils
  
  # rotate the provided file with a maximum of 'limit' backups
  # renamed filed will be named file_0, file_1, ...
  def LockrFileUtils.rotate_file( file, limit)
    return unless File.exists?(file)
    
    # move old files first
    max_files = limit - 1 
    max_files.downto( 0) { |i|
      
      if i == 0
        LockrFileUtils.copy( file, "#{file}_#{i}")
      else
        j = i - 1
        if File.exists?("#{file}_#{j}")
          LockrFileUtils.copy( "#{file}_#{j}", "#{file}_#{i}")  
        end
      end
    }
    
    puts "Rotated local vault file(s)"
  end  
  
  # copy file_src to file_target
  def LockrFileUtils.copy( file_src, file_target)
    return unless File.exists?( file_src)
    
    dst = File.new( file_target, 'w')
    File.open( file_src, 'r') do |src|
      dst.write( src.read)
    end
    dst.close
  end
  
  # store an object as yaml to file
  def LockrFileUtils.store_obj_yaml( file, object)
    File.open( file, 'w') do |f|
      f.write( object.to_yaml)
    end
  end
  
  # load an yaml object from file
  def LockrFileUtils.load_obj_yaml( file)
    object = {}
    
    unless File.exist?( file)
      return object
    end
    
    File.open( file, 'r') do |f|
      object = YAML::load(f)
    end
    
    object
  end
  
  # calculate the sha512 hash of a file
  def LockrFileUtils.calculate_sha512_hash( filename)
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
    LockrFileUtils.store_obj_yaml( vault, storelist)
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
    LockrFileUtils.load_obj_yaml( vault)
  end
end