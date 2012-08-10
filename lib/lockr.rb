require 'rubygems'
require 'bundler/setup'

require 'optparse'
require 'highline/import'

require 'lockr/action/add'
require 'lockr/action/list'
require 'lockr/action/remove'
require 'lockr/action/show'
require 'lockr/config'
require 'lockr/pwdgen'
require 'lockr/version'
  
class Lockr
  
  def run()
    options = parse_options()
    merge_config( options)
    validate_options( options)
    acquire_additional_input( options)
    process_actions( options)
  end
  
  def parse_options()
    options = {}
    
    optparse = OptionParser.new do|opts|
    # Set a banner, displayed at the top
    # of the help screen.
      opts.banner = "Usage: lockr.rb [options]"
    
      # Define the options, and what they do
      options[:action] = nil
      opts.on( '-a', '--action ACTION', 'Execute the requested ACTION (add, remove, list, show)' ) do |id|
        options[:action] = id
      end
    
      options[:id] = nil
      opts.on( '-i', '--id ID', 'the ID of the password set' ) do |id|
        options[:id] = id
      end
      
      options[:keyfile] = nil
      opts.on( '-k', '--keyfile FILE', 'the FILE to use as key for the password encryption') do |file|
        options[:keyfile] = file
      end
      
      options[:vault] = 'vault.yaml'
      opts.on( '-v', '--vault FILE', 'FILE is the name of the vault to store the password sets') do |file|
        options[:vault] = file
      end
      
      options[:generatepwd] = nil
      opts.on( '-g', '--genpwd PARAMS', 'generate a random password (based on the optional PARAMS)') do |params|
        options[:generatepwd] = params
      end
    
      # This displays the help screen, all programs are
      # assumed to have this option.
      opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
      end
      
      opts.on('-v', '--version', 'Show version') do
        puts "Lockr #{LockrVer::VERSION} (#{LockrVer::DATE})"
        exit
      end
      
      opts.separator ""
      opts.separator "For detailed instructions on how to use Lockr, please visit http://lockr.byteblues.com"
    end
    
    # Parse the command-line. Remember there are two forms
    # of the parse method. The 'parse' method simply parses
    # ARGV, while the 'parse!' method parses ARGV and removes
    # any options found there, as well as any parameters for
    # the options. What's left is the list of files to resize.
    optparse.parse!
  
    options
  end
  
  def merge_config( options)
    configfile = Configuration.new()
    
    if configfile.config.nil? 
      return
    end
    
    unless configfile.config.has_key?( :lockr)
      return
    end
    
    cfg = configfile.config[:lockr]
    options[:vault] = File.expand_path(cfg[:vault]) if options[:vault] == 'vault.yaml'
  end
  
  def validate_options( options)
    if options[:action].nil?
      puts 'Please provide an action (--action)'
      exit 1
    end
    
    allowed_actions = %w{ a add r remove s show l list}
    if allowed_actions.index( options[:action]).nil? 
      puts "Allowed actions are add, remove, list and show"
      exit 2
    end
    
    # keyfile is required for all actions other than list
    if options[:keyfile].nil? and %w{ l list}.index( options[:action]).nil?
      puts 'Please provide an encryption key file (--keyfile)'
      exit 3
    end
  end
  
  def acquire_additional_input( options)
    # id is required for all actions except list
    while options[:id].nil? and %w{ l list}.index( options[:action]).nil?
      options[:id] = ask("Id?  ") { |q| }
      options[:id] = nil if options[:id].strip() == '' 
    end
    
    # username is required for actions add, remove
    actions_requiring_username = %w{ a add r remove}
    while options[:username].nil? and not actions_requiring_username.index( options[:action]).nil?
      options[:username] = ask("Username?  ") { |q| }
      options[:username] = nil if options[:username].strip == ''
    end
    
    # url is optional for add
    actions_requiring_url = %w{ a add}
    if options[:url].nil? and not actions_requiring_url.index( options[:action]).nil?
      options[:url] = ask("Url?  ") { |q| }
      options[:url] = nil if options[:url].strip() == ''
    end
  end
  
  def process_actions( options)
    begin
      case options[:action]
      when 'a', 'add'
        if options[:generatepwd].nil?
          password = ask("Password?  ") { |q| q.echo = "x" }
        else 
          password = PasswordGenerator.new.generate( options[:generatepwd])
        end 
        
        action = AddAction.new( options[:id], options[:url], options[:username], password, options[:keyfile], options[:vault])
      when 'r', 'remove'
        action = RemoveAction.new( options[:id], options[:username], options[:keyfile], options[:vault])
      when 's', 'show'
        action = ShowAction.new( options[:id], options[:username], options[:keyfile], options[:vault])
      when 'l', 'list'
        action = ListAction.new( options[:keyfile], options[:vault])
      else
        puts "Unknown action #{options[:action]}"
      end
    rescue OpenSSL::Cipher::CipherError
      say( "<%= color('Invalid keyfile', :red) %>")
      exit 42
    end
  end
end