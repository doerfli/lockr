require 'lockr/pwdmgr'

class BaseAction
  def initialize( keyfile, vault)
    @pwdmgr = PasswordManager.new( keyfile, vault)
  end
end