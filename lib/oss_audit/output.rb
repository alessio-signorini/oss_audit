require 'json'
require 'csv'

module OssAudit
  module Output

    def self.format(dependencies, type='json', simple=true)
      send("as_#{type}", uniq(dependencies), simple)
    end

    def self.as_csv(dependencies, simple=true)
      headers = dependencies.map{|x| x.keys}.flatten.uniq

      if simple
        headers = %w(manager name version licenses homepage source)
        dependencies = simplify(dependencies)
      end
      
      return CSV.generate('', :headers => headers, :col_sep => "\t", :write_headers => true) do |csv|
        dependencies.each do |dependency|
          csv << headers.map{|x| dependency[x]}.map{|x| to_s(x)}
        end
      end
    end

    def self.as_json(dependencies, simple=true)
      dependencies = simplify(dependencies) if simple
      return JSON.pretty_generate(dependencies)
    end

    def self.simplify(dependencies)
      keys = %w(manager name version licenses homepage source)
      return dependencies.map{|x| x.slice(*keys)}
    end

    def self.to_s(object)
      object.is_a?(Array) ? (object.empty? ? nil : object.join(',')) : object
    end
    
    def self.uniq(dependencies)
      dependencies
        .uniq{|x| x['name']}
        .sort{|a,b| a['name'] <=> b['name']}
    end
  end
end
