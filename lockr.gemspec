# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lockr/version"

Gem::Specification.new do |s|
  s.name        = 'lockr'
  s.version     = LockrVer::VERSION
  s.date        = LockrVer::DATE
  s.executables << 'lockr'
  s.executables << 'httplockr'
  s.summary     = 'Password manager with local web gui and command line tools'
  s.description = 'Lockr is a password manager that features a web interface as well as command line function to manage your passwords. Passwords are stored AES-encrypted in a file on your own system and can (if you want) be uploaded to your own "cloud" via ssh.'
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
                   'lib/lockr/config.rb',
                   'lib/lockr/fileutils.rb',
                   'lib/lockr/pwdgen.rb',
                   'lib/lockr/pwdstore.rb',
                   'lib/lockr/sftp.rb',
                   'lib/lockr/version.rb']
  s.homepage    = 'http://lockr.byteblues.com/'
  
  s.add_dependency( 'highline', '>=1.6.13')
  s.add_dependency( 'bundler', '>=1.1.4')
  s.add_dependency( 'net-sftp', '>=2.0.5')
  s.add_dependency( 'sinatra', '~>1.4.4')
end
