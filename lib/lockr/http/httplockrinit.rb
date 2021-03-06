require 'optparse'
require 'lockr/config'
require 'lockr/pwdmgr'
    
class HttpLockrInit
  
  def start()
    options = parse_options()
    
    unless options[:keyfile]
      puts 'Please provide a keyfile'
      raise ArgumentError
    end
    
    configfile = Configuration.new()
    cfg = nil
    if configfile.config
      cfg = configfile.config[:lockr]
    end
    options[:vault] = File.expand_path(cfg[:vault]) if options[:vault] == 'vault.yaml' and cfg != nil
    
    @pwdmgr = PasswordManager.new( options[:keyfile], options[:vault])
    @load_browser = options[:browser]
  end
  
  def getPwdMgr
    return @pwdmgr
  end
  
  def getLoadBrowser
    return @load_browser
  end
  
  def parse_options()
    options = {}
    
    optparse = OptionParser.new do|opts|
    # Set a banner, displayed at the top
    # of the help screen.
      opts.banner = "Usage: httplockr [options]"
    
      options[:keyfile] = nil
      opts.on( '-k', '--keyfile FILE', 'the FILE to use as key for the password encryption') do |file|
        options[:keyfile] = File.expand_path(file)
      end
      
      options[:vault] = 'vault.yaml'
      opts.on( '-v', '--vault FILE', 'FILE is the name of the vault to store the password sets') do |file|
        options[:vault] = File.expand_path(file)
      end
      
      options[:browser] = false
      opts.on( '-b', '--browser', 'open browser windows for lockr') do |d|
        options[:browser] = true
      end
      
      # This displays the help screen, all programs are
      # assumed to have this option.
      opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
      end
      
      opts.on('--version', 'Show version') do
        puts "HttpLockr #{LockrVer::VERSION} (#{LockrVer::DATE})"
        exit
      end
      
      opts.separator ""
      opts.separator "For detailed instructions on how to use HttpLockr, please visit http://lockr.byteblues.com"
    end
    
    # Parse the command-line. Remember there are two forms
    # of the parse method. The 'parse' method simply parses
    # ARGV, while the 'parse!' method parses ARGV and removes
    # any options found there, as well as any parameters for
    # the options. What's left is the list of files to resize.
    optparse.parse!
  
    options
  end
end