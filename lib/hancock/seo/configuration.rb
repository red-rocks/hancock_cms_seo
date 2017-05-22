module Hancock::Seo
  include Hancock::PluginConfiguration

  def self.config_class
    Configuration
  end

  class Configuration
    attr_accessor :localize

    attr_accessor :gallery_support
    attr_accessor :cache_support
    attr_accessor :insertions_support

    attr_accessor :model_settings_support
    attr_accessor :user_abilities_support
    attr_accessor :ra_comments_support

    def initialize
      @localize = Hancock.config.localize

      @gallery_support = !!defined?(Hancock::Gallery)
      @cache_support  = !!defined?(Hancock::Cache)
      @insertions_support = true 

      @model_settings_support = !!defined?(RailsAdminModelSettings)
      @user_abilities_support = !!defined?(RailsAdminUserAbilities)
      @ra_comments_support = !!defined?(RailsAdminComments)
    end
  end
end
