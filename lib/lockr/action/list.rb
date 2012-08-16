require 'lockr/action/aes'
require 'lockr/pwdstore'

class ListAction < AesAction
  
  def initialize( keyfile, vault)
    pwd_directory = load_from_vault( vault)
    out = []
    
    if keyfile.nil?
      pwd_directory.each { |id,value|
        out << "Id: #{id}"
      }
    else
      keyfilehash = calculate_sha512_hash( keyfile)
      pwd_directory.each { |oid,value|
        pwd_directory_id = YAML::load(decrypt( value[:enc], keyfilehash, value[:salt]))
        pwd_directory_id.each { |username, pwdstore|
          out << "Id: #{pwdstore.id} / Username: #{pwdstore.username}"
        }
      }
    end
    
    out.sort!
    out.each{ |e| puts e }
  end
  
end 