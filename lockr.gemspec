Gem::Specification.new do |s|
  s.name        = 'lockr'
  s.version     = '0.1.0'
  s.executables << 'lockr'
  s.date        = '2012-08-01'
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
  s.add_dependency( 'bundler')
end
