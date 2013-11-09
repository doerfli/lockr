require 'lockr/action/base'
require 'lockr/pwdmgr'

class AesAction < BaseAction
  
  def initialize( keyfile, vault)
    @pwdmgr = PasswordManager.new( keyfile, vault)
  end
  
end