require 'securerandom'
require 'highline/import'

class PasswordGenerator
  
  ALPHA = ('A'..'Z').to_a|('a'..'z').to_a
  ALPHA_NUM = ('A'..'Z').to_a|('a'..'z').to_a|('0'..'9').to_a
  ALPHA_NUM_SYM = (' '..'!').to_a|('#'..'[').to_a|(']'..'~').to_a
  
  # generate a random password. 
  # format of parameter: 
  # rxx - r = type (a ... alpha, n ... alpha + num, s ... alpha + num + sym) and xx = password length 
  # 
  # example: n10 -> GcQfP4OBFh
  # a12 -> DChpRnhpHiha
  # s18 -> JHnXZ<hrcVKorO6mO:
  def generate( params)
    pwd = []
    range = nil
    
    case params[0]
    when 's'
      range = ALPHA_NUM_SYM
    when 'n'
      range = ALPHA_NUM
    when 'a'
      range = ALPHA
    else
      puts 'Invalid parameter: ' + params
      exit 50
    end
    
    # create x random characters
    params[1..params.length].to_i.times do
      l = SecureRandom.random_number(range.length)
      pwd << range[l]
    end
    
    pwd = pwd.join
    # print pwd with single quote escape
    say( "<%= color( 'Generated password: #{pwd.gsub( "'", "\\\\'")}', :yellow) %>")
    pwd
  end
end