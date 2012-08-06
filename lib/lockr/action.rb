require 'openssl'
require 'highline/import'
require_relative 'action'
require_relative 'aespwdstore'











class ListAction < BaseAction
  def initialize(vault)
    stores = load_from_vault( vault)
    
    stores.each { |id,value|
      value.each { |username, store|
        puts "Id: #{id} / Username: #{username}"
      } 
    }
  end
end    



