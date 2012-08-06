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
                   'lib/lockr/action/add.rb',
                   'lib/lockr/action/aes.rb',
                   'lib/lockr/action/base.rb',
                   'lib/lockr/action/list.rb',
                   'lib/lockr/action/remove.rb',
                   'lib/lockr/action/show.rb',
                   'lib/lockr/encryption/aes.rb',
                   'lib/lockr/pwdgen.rb',
                   'lib/lockr/pwdstore.rb']
  s.homepage    = 'http://lockr.byteblues.com/'
  
  s.add_dependency( 'highline')
  s.add_dependency( 'bundler')
end
