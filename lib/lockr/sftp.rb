require 'lockr/config'
require 'net/sftp'

class SFTP
  
  # upload the vault via sftp to the location specified in the configuration
  def upload( config, vault)
    cfg_sftp = get_sftp_config( config)
    
    Net::SFTP.start( cfg_sftp[:hostname], cfg_sftp[:username]) do |sftp|
      
      # TODO rotate existing remote vault before upload
      
      # upload a file or directory to the remote host
      sftp.upload!( vault, File.join( cfg_sftp[:directory], File.basename(vault)))
      puts "Uploaded vault to host '#{cfg_sftp[:hostname]}' by SFTP"
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