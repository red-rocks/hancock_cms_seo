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
          [:show, :read, :edit, :update].freeze
        end
        def self.manager_can_default_actions
          [:show, :read, :edit, :update].freeze
        end
        def self.admin_cannot_actions
          [:new, :create].freeze
        end
        def self.manager_cannot_actions
          [:new, :create].freeze
        end

        def self.manager_can_add_actions
          ret = [:nested_set]
          # ret += [:multiple_file_upload, :sort_embedded] if Hancock::Seo.mongoid?
          ret << :model_settings if Hancock::Seo.config.model_settings_support
          ret << :model_accesses if Hancock::Seo.config.user_abilities_support
          ret += [:comments, :model_comments] if Hancock::Seo.config.ra_comments_support
          ret.freeze
        end
        def self.rails_admin_add_visible_actions
          ret = [:nested_set]
          # ret += [:multiple_file_upload, :sort_embedded] if Hancock::Seo.mongoid?
          ret << :model_settings if Hancock::Seo.config.model_settings_support
          ret << :model_accesses if Hancock::Seo.config.user_abilities_support
          ret += [:comments, :model_comments] if Hancock::Seo.config.ra_comments_support
          ret.freeze
        end

      end
    end
  end
end
