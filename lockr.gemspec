# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lockr/version"

Gem::Specification.new do |s|
  s.name        = 'lockr'
  s.version     = LockrVer::VERSION
  s.date        = LockrVer::DATE
  s.executables << 'lockr'
  s.executables << 'httplockr.rb'
  s.summary     = 'Password manager with local web interface and command line tools'
  s.description = """Lockr is a password manager that features a local web interface 
                     (no cloud, all on your local machine) as well as command line function 
                     to manage your passwords. Passwords are stored AES-encrypted in a file 
                     on your own system and can (if you want) be uploaded to your own 
                     'cloud' via ssh."""
  s.authors     = ['Marc Doerflinger']
  s.email       = 'info@byteblues.com'
  s.files       = Dir.glob("{bin,lib,resources}/**/*")
  s.homepage    = 'http://lockr.byteblues.com/'
  
  s.add_dependency( 'highline', '>=1.6.13')
  s.add_dependency( 'bundler', '>=1.1.4')
  s.add_dependency( 'net-sftp', '>=2.0.5')
  s.add_dependency( 'sinatra', '~>1.4.4')
  s.add_dependency( "clipboard", "~> 1.0.5")
  s.add_dependency( "rufus-scheduler", "~> 3.0.2")
  s.add_dependency( "padrino-helpers", "~> 0.11.4")
  s.add_dependency( 'browser_gui', "~>0.1.0")
end
