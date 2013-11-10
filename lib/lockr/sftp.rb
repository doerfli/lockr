require 'lockr/config'
require 'net/sftp'
require 'set'
require 'lockr/fileutils'

class SFTP
  include LockrFileUtils
  
  # upload the vault via sftp to the location specified in the configuration
  def upload( config, vault)
    cfg_sftp = get_sftp_config( config)
    remote_file = File.join( cfg_sftp[:directory], File.basename(vault))
    Net::SFTP.start( cfg_sftp[:hostname], cfg_sftp[:username]) do |sftp|
      
      # TODO check remote checksum to make sure upload is necessary
      rotate_sftp_file( sftp, remote_file, 3)
      
      # upload a file or directory to the remote host
      sftp.upload!( vault, remote_file)
      puts "Uploaded vault to host '#{cfg_sftp[:hostname]}' by SFTP"
    end
  end
  
  # rotate the provided file with a maximum of 'limit' backups
  # renamed filed will be named file_0, file_1, ...
  def rotate_sftp_file( sftp, file, limit)
    return unless file_exists( sftp, file)
    
    # move old files first
    max_files = limit - 1 
    max_files.downto( 0) { |i|
      
      if i == 0
        sftp.rename( file, "#{file}_#{i}")
      else
        j = i - 1
        next unless file_exists( sftp, "#{file}_#{j}")
        sftp.rename( "#{file}_#{j}", "#{file}_#{i}")  
      end
    }
    
    puts "Rotated remote vault file(s)"
  end  
  
  # check if the file exists on the given sftp connection
  def file_exists( sftp, file)
    files = get_dir_listing( sftp, File.dirname(file))
    files.include?( File.basename(file))
  end
  
  # get the file listing of a remote directory
  def get_dir_listing( sftp, dir)
    list = []

    sftp.dir.foreach(dir) do |entry|
      list << entry.name
    end

    Set.new(list)
  end
  
  # download the vault via sftp to the location specified in the configuration
  def download( config, vault)
    cfg_sftp = get_sftp_config( config)
    
    Net::SFTP.start( cfg_sftp[:hostname], cfg_sftp[:username]) do |sftp|
      # download a file or directory from the remote host
      sftp.download!( File.join( cfg_sftp[:directory], File.basename(vault)), vault)
      puts "Downloaded vault from host '#{cfg_sftp[:hostname]}' by SFTP"
    end
  end
  
  # check config for section lockr and subsection sftp. then check for keys 
  # :hostname, :username and :directory. if anything is missing, raise ArgumentError
  # returns sftp configuration hash
  def get_sftp_config( config)
    unless config.config.has_key?( :lockr)
      raise ArgumentError, 'config has no "lockr" section'
    end
    
    cfg = config.config[:lockr]
    
    unless cfg.has_key?( :sftp)
      raise ArgumentError, 'config has no "sftp" section'
    end
    
    cfg_sftp = cfg[:sftp]
    
    unless cfg_sftp.has_key?( :hostname) and cfg_sftp.has_key?( :username) and cfg_sftp.has_key?( :directory)
      raise ArgumentError, 'config "sftp" section must have keys :host, :username and :directory'
    end
     
     cfg_sftp
  end
  
end