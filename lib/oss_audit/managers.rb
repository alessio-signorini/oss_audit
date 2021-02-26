require_relative 'utils'
require_relative 'managers/bundler'
require_relative 'managers/yarn'

module OssAudit
  module Managers
    
    def self.list
      constants(false).map{|x| const_get(x)}
    end
    
  end
end