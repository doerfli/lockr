require 'securerandom'

class PasswordGenerator
  
  def generate( params)
    pwd = []
    
    # create x random characters
    params.to_i.times do
      l = SecureRandom.random_number(26)
      pwd << l
    end
    
    # up/downcase with 50% chance
    pwd.collect!{ |i| (i + 65).chr }.collect!{ |c| 
      if ( SecureRandom.random_number(0) > 0.5)
        c.downcase 
      else
        c
      end 
    }
    
    pwd.join
  end
end