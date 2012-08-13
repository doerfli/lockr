# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lockr/version"

Gem::Specification.new do |s|
  s.name        = 'lockr'
  s.version     = LockrVer::VERSION
  s.date        = LockrVer::DATE
  s.executables << 'lockr'
  s.summary     = 'Command line based password manager'
  s.description = 'Lockr is a command line based password manager. Passwords are stored AES-encrypted in a file on your own system.'
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
                   'lib/lockr/pwdgen.rb',
                   'lib/lockr/pwdstore.rb',
                   'lib/lockr/version.rb']
  s.homepage    = 'http://lockr.byteblues.com/'
  
  s.add_dependency( 'highline')
  s.add_dependency( 'bundler')
end
