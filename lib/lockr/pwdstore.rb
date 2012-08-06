# A password store contains an id of the site the password belongs to, 
# the username to login and the password. 
    
class PasswordStore
    attr_accessor :id,:url,:username,:password
    
    def initialize(id,url,username,pwd)
      @id = id
      @url = url
      @username = username
      @password = pwd
    end
end