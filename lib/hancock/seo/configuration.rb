module Hancock::Seo
  include Hancock::PluginConfiguration

  def self.config_class
    Configuration
  end

  class Configuration
    attr_accessor :localize

    attr_accessor :gallery_support

    def initialize
      @localize = Hancock.config.localize

      @gallery_support = defined?(Hancock::Gallery)
    end
  end
end
