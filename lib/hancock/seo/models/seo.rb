module Hancock::Seo
  module Models
    module Seo
      extend ActiveSupport::Concern
      include Hancock::Model
      include Hancock::Enableable
      if Hancock::Seo.config.gallery_support
        include Hancock::Gallery::Paperclipable
      end

      include Hancock::Seo.orm_specific('Seo')

      included do
        belongs_to :seoable, polymorphic: true

        def self.goto_hancock
          self.where(seoable_type: /^Enjoy/).all.map { |s|
            unless s.seoable.blank?
              s.seoable_type = s.seoable_type.sub("Enjoy", "Hancock")
              s.seoable_type = "Hancock::Pages::Page" if s.seoable_type == "Hancock::Page"
              s.seoable_type = "Hancock::Catalog::Category" if s.seoable_type == "Hancock::Catalog::ItemCategory"
              s.seoable_type = "Hancock::News::Category" if s.seoable_type == "Hancock::News::NewsCategory"
            end
            s.save
          }
        end

        if Hancock::Seo.config.gallery_support
          hancock_cms_attached_file :og_image
        end

        before_save do
          set_default_seo
        end


        def self.admin_can_default_actions
          [:show, :read, :edit, :update]
        end
        def self.manager_can_default_actions
          [:show, :read, :edit, :update]
        end
        def self.admin_cannot_actions
          [:new, :create]
        end
        def self.manager_cannot_actions
          [:new, :create]
        end
      end

      def set_default_seo
        _obj = self.seoable
        if _obj and _obj.set_default_seo?
          self.h1           = _obj.default_seo_h1           if self.h1.blank?
          self.title        = _obj.default_seo_title        if self.title.blank?
          self.keywords     = _obj.default_seo_keywords     if self.keywords.blank?
          self.description  = _obj.default_seo_description  if self.description.blank?
          self.title        = _obj.default_seo_og_title     if self.title.blank?
        end
      end

      def og_image_styles
        {thumb: "800x600>"}
      end

      def og_image_jcrop_options
        {}
      end

    end
  end
end
