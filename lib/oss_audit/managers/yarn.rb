module OssAudit
  module Managers
    module Yarn
      extend OssAudit::Utils

      def self.packages_files(directory)
        Dir.glob(File.join(directory, '**/package.json')).reject{|x| x.include?('node_modules')}
      end

      def self.used_in?(directory)
        packages_files(directory).any?
      end

      def self.list_dependencies(directory)
        packages_files(directory).map do |file|
          data = JSON.parse(File.read(file))
          ((data['dependencies']||{}).keys | (data['devDependencies']||{}).keys)
        end.flatten
      end

      def self.get_info(package, version=nil)
        data = get_uri("https://registry.yarnpkg.com/#{package}/#{version||'latest'}")
        
        unless data.is_a?(Hash)
          OssAudit.logger.error{"#{package} | #{data}"}
          return
        end

        name          = data['name']
        licenses      = Array(data['license'])
        homepage      = data['homepage']
        source        = data.dig('repository','url')

        dependencies  = (data['dependencies']||{}).keys


        return {
          "name"          => name,
          "licenses"      => licenses,
          "homepage"      => homepage,
          "source"        => source,
          "dependencies"  => dependencies
        }
      end

    end
  end
end
