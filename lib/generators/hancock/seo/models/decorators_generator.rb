require 'rails/generators'

module Hancock::Seo::Models
  class DecoratorsGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../../../../app/models/concerns/hancock/seo/decorators', __FILE__)
    argument :models, type: :array, default: []

    desc 'Hancock::Seo Models decorators generator'
    def decorators
      copied = false
      (models == ['all'] ? permitted_models : models & permitted_models).each do |m|
        copied = true
        copy_file "#{m}.rb", "app/models/concerns/hancock/seo/decorators/#{m}.rb"
      end
      puts "U need to set model`s name. One of this: #{permitted_models.join(", ")}." unless copied
    end

    private
    def permitted_models
      ['seo', 'sitemap_data']
    end

  end
end
