require 'json'

module OssAudit
  module Overrides

    def self.patch!(dependencies, overrides_file)
      overrides = index(overrides_file)

      dependencies.each do |dep|
        id = key(dep)
        if overrides.include?(id)
          OssAudit.logger.debug("  - Overriding #{dep['name']}")
          dep.merge!(overrides[id])
        end
      end
    end

    def self.index(overrides_file)
      data = JSON.parse(File.read(overrides_file)) rescue nil
        abort("ERROR: Cannot read/parse JSON from #{overrides_file}") unless data

      return Array(data).map{|x| [key(x), x]}.to_h
    end

    def self.key(dependency)
      ['manager', 'name'].map{|x| dependency[x]}.join('#')
    end

  end
end
