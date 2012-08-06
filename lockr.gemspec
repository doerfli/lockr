Gem::Specification.new do |s|
  s.name        = 'lockr'
  s.version     = '0.2.0'
  s.executables << 'lockr'
  s.date        = '2012-08-06'
  s.summary     = 'Safe password storage'
  s.description = 'Store your passwords AES encrypted in a simple yaml file'
  s.authors     = ['Marc Doerflinger']
  s.email       = 'info@byteblues.com'
  s.files       = ['lib/lockr.rb',
                   'lib/lockr/action.rb',
                   'lib/lockr/aespwdstore.rb',
                   'lib/lockr/pwdstore.rb']
  s.homepage    = 'http://lockr.byteblues.com/'
  
  s.add_dependency( 'highline')
end
