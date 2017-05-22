require "hancock/seo/version"

require 'sitemap_generator'
require 'rails_admin_sitemap'
require 'rails_admin_robots_txt'

require 'hancock/seo/configuration'
require 'hancock/seo/engine'


module Hancock::Seo
  include Hancock::Plugin

  class << self
    def clear_empty_objects
      [Hancock::Seo::Seo, Hancock::Seo::SitemapData].map { |model|
        model.clear_empty_objects
      }
    end
  end

  autoload :Admin,  'hancock/seo/admin'
  module Admin
    autoload :SitemapData,  'hancock/seo/admin/sitemap_data'
    autoload :Seo,          'hancock/seo/admin/seo'
    autoload :Event,        'hancock/seo/admin/event'
  end

  module Models
    autoload :SitemapData,  'hancock/seo/models/sitemap_data'
    autoload :Seo,          'hancock/seo/models/seo'
    autoload :Event,        'hancock/seo/models/event'

    module Mongoid
      autoload :SitemapData,  'hancock/seo/models/mongoid/sitemap_data'
      autoload :Seo,          'hancock/seo/models/mongoid/seo'
      autoload :Event,        'hancock/seo/models/mongoid/event'
    end

    module ActiveRecord
      autoload :SitemapData,  'hancock/seo/models/active_record/sitemap_data'
      autoload :Seo,          'hancock/seo/models/active_record/seo'
      autoload :Event,        'hancock/seo/models/active_record/event'
    end
  end

end
