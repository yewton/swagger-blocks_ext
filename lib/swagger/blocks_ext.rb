require "json"
require "swagger/blocks"
require "swagger/blocks_ext/version"
require "yaml"

module Swagger
  module BlocksExt
    class Configuration
      attr_accessor :descriptions_path
    end

    class << self
      attr_writer :configuration
    end

    # @return [Configuration]
    def self.configuration
      @configuration ||= Configuration.new
    end

    # Reset the configuration.
    def self.reset
      @configuration = Configuration.new
    end

    # @yieldparam configuration [Configuration]
    # @example Configure descriptions path
    #   Swagger::BlocksExt.configure {|c| c.descriptions_path = ::File.join(__dir__, 'descriptions') }
    def self.configure
      yield(configuration)
    end

    module NodeExt
      refine Swagger::Blocks::Node do
        # @param name [String] file name for the description(without extension)
        # @return [String] description string read from file
        def md(name)
          basedir = Swagger::BlocksExt.configuration.descriptions_path
          unless basedir
            raise "`descriptions_path' is not configured. Swagger::BlocksExt.configure first."
          end
          dir = self.class.name.downcase.gsub(/::/, '/').gsub(/swagger\/blocks\//, '').gsub(/node/, '')
          path = ::File.expand_path(::File.join(basedir, dir, "#{name}.md"))
          raise "cannot read #{path}" unless ::File.readable?(path)
          ::File.read(path, encoding: 'UTF-8').chomp
        end
      end
    end

    def to_hash
      swaggered_classes = ObjectSpace.each_object(Class).select {|c|
        c.include?(Swagger::Blocks) && c.name
      }.map {|c|
        # avoid class collision in rspec...
        Object.const_get(c.name)
      }.uniq
      Swagger::Blocks.build_root_json(swaggered_classes) unless swaggered_classes.empty?
    end

    def to_json
      to_hash.to_json
    end

    def to_yaml
      JSON.parse(to_json).to_yaml
    end

    module_function :to_hash, :to_json, :to_yaml
  end
end
