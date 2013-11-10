require 'lockr/action/base'

class AddAction < BaseAction
  
  def initialize(id,url,username,pwd,keyfile,vault)
    super( keyfile, vault)
    pwd_directory = @pwdmgr.list()
    
    if pwd_directory.has_key?( id)
      pwd_directory_id = pwd_directory[id]
    else
      pwd_directory_id = {}
    end
    
    if ( pwd_directory_id.has_key?( username))
      overwrite = ask( "Password already exists. Update? (y/n)  ") { |q| }
      unless overwrite.downcase == 'y'
        exit 14
      end
    end
    
    # ###TODO add url
    @pwdmgr.add( id, username, pwd)
    say("Password saved for ID '<%= color('#{id}', :blue) %>' and user '<%= color('#{username}', :green) %>'")
  end
  
end