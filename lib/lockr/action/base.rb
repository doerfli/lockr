require 'openssl'
require 'lockr/encryption/aes'
require 'lockr/fileutils'

class BaseAction
  include LockrFileUtils
end