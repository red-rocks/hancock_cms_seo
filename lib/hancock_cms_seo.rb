# unless defined?(Hancock) && Hancock.respond_to?(:orm) && [:active_record, :mongoid].include?(Hancock.orm)
#   puts "please use hancock_cms_mongoid or hancock_cms_activerecord"
#   puts "also: please use hancock_cms_news_mongoid or hancock_cms_news_activerecord and not hancock_cms_news directly"
#   exit 1
# end

require "hancock/seo/version"

require 'sitemap_generator'
require 'rails_admin_sitemap'

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
  end

  module Models
    autoload :SitemapData,  'hancock/seo/models/sitemap_data'
    autoload :Seo,          'hancock/seo/models/seo'

    module Mongoid
      autoload :SitemapData,  'hancock/seo/models/mongoid/sitemap_data'
      autoload :Seo,          'hancock/seo/models/mongoid/seo'
    end

    module ActiveRecord
      autoload :SitemapData,  'hancock/seo/models/active_record/sitemap_data'
      autoload :Seo,          'hancock/seo/models/active_record/seo'
    end
  end

end
