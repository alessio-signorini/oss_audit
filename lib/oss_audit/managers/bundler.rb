module OssAudit
  module Managers
    module Bundler
      extend OssAudit::Utils

      def self.used_in?(directory)
        File.exists?(File.join(directory, 'Gemfile.lock')) || File.exists?(File.join(directory, 'Gemfile'))
      end

      def self.list_dependencies(directory)
        file = File.read(File.join(directory, 'Gemfile'))

        file.gsub!(/\#.*/,'')

        return file.scan(/gem\s["'](\w+)["']/).flatten.uniq
      end

      def self.get_info(package, version=nil)
        data = get_uri("https://rubygems.org/api/v1/gems/#{package}.json")
        
        if data.is_a?(Exception)
          OssAudit.logger.error{"#{package} | #{data}"}
          return
        end

        name          = data['name']
        licenses      = Array(data['license'] || data['licenses'])
        homepage      = data['homepage_uri'] || data.dig('metadata','homepage_uri') || data['project_uri']
        source        = data['source_code_uri'] || data.dig('metadata','source_code_uri')

        dependencies  = data['dependencies']['runtime'].map{|k| k['name']}

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
