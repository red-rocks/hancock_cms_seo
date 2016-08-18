require 'rails/generators'

module Hancock::Seo
  class ConfigGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'Hancock::Seo Config generator'
    def config
      template 'hancock_seo.erb', "config/initializers/hancock_seo.rb"
    end

  end
end
