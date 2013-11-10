require 'lockr/action/base'

class RemoveAction < BaseAction
  
  def initialize(id,username,keyfile,vault)
    super( keyfile, vault)
    
    pwd_directory = @pwdmgr.list()
    
    unless pwd_directory.has_key?( id)
      puts "Id '#{id}' not found"
      exit 20
    end
    
    pwd_directory_id = pwd_directory[id]
    
    unless pwd_directory_id.has_key?(username)
      puts "Username '#{username}' not found for id '#{id}'"
      exit 21
    end
    
    confirm = ask( "Are you sure you want to delete the entry with id '#{id}' and username '#{username}'? (y/n)  ") { |q| }
    unless confirm.downcase == 'y'
      exit 22
    end
    
    @pwdmgr.delete( id, username)
    puts "Entry removed"
  end
  
end