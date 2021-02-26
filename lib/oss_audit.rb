require "oss_audit/version"
require "oss_audit/managers"
require "oss_audit/output"
require 'oss_audit/overrides'

require 'logger'

module OssAudit
  class Error < StandardError; end

  def self.logger
    @@logger ||= Logger.new(STDERR)
  end

  def self.scan(path)
    libraries = []
    Managers.list.each do |manager|
      next unless manager.used_in?(path)

      logger.info{"#{manager} (#{path})"}

      dependencies = manager.list_dependencies(path)

      logger.debug{"* Found #{dependencies.count} dependencies"}

      dependencies.each do |dependency|
        name, version = Array(dependency)

        info      = manager.get_info(name, version) or next
        defaults  = {
          'name'          => name,
          'version'       => version,
          'manager'       => manager.name.split('::').last,
          'dependencies'  => []
        }

        libraries << defaults.merge(info)
      end
    end
    
    return libraries
  end
end
