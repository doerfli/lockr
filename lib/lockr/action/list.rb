require 'lockr/action/base'

class ListAction < BaseAction
  
  def initialize( keyfile, vault)
    super( keyfile, vault)
    pwdlist = @pwdmgr.list()
    out = []
    
    if keyfile.nil?
      pwdlist.each { |id,value|
        out << "Id: #{id}"
      }
    else
      pwdlist.each { |oid,site_directory|
        pwd_directory_id = site_directory
        pwd_directory_id.each { |username, pwdstore|
          out << "Id: #{pwdstore.id} / Username: #{pwdstore.username}"
        }
      }
    end
    
    out.sort!
    out.each{ |e| puts e }
  end
  
end 