module Hancock::Seo
  module Models
    module SitemapData
      extend ActiveSupport::Concern
      include Hancock::Model
      include Hancock::Enableable

      include Hancock::Seo.orm_specific('SitemapData')

      SITEMAP_CHANGEFREQ_ARRAY = %w(always hourly daily weekly monthly yearly never)

      included do
        belongs_to :sitemap_data_field, polymorphic: true

        def self.goto_hancock
          self.where(sitemap_data_field_type: /^Enjoy/).all.map { |s|
            unless s.sitemap_data_field.blank?
              s.sitemap_data_field_type = s.sitemap_data_field_type.sub("Enjoy", "Hancock");
              s.sitemap_data_field_type = "Hancock::Pages::Page" if s.sitemap_data_field_type == "Hancock::Page"
              s.sitemap_data_field_type = "Hancock::Catalog::Category" if s.sitemap_data_field_type == "Hancock::Catalog::ItemCategory"
              s.sitemap_data_field_type = "Hancock::News::Category" if s.sitemap_data_field_type == "Hancock::News::NewsCategory"
            end
            s.save
          }
        end

        def self.admin_can_default_actions
          [:show, :read, :edit, :update]
        end
        def self.manager_can_default_actions
          [:show, :read, :edit, :update]
        end
      end
    end
  end
end
