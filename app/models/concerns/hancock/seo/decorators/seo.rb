module Hancock::Seo::Decorators
  module Seo
    extend ActiveSupport::Concern

    included do
      # # after_save :og_image_auto_rails_admin_jcrop
      # def og_image_auto_rails_admin_jcrop
      #   auto_rails_admin_jcrop(:og_image) # or nil for cancel autocrop
      # end

      # hancock_cms_attached_file(:og_image)
      # def og_image_styles
      #   {thumb: "800x600>"}
      # end
      #
      # def og_image_jcrop_options
      #   {}
      # end
      #
      #
      # def set_default_seo
      #   _obj = self.seoable
      #   if _obj and _obj.set_default_seo?
      #     self.h1           = _obj.default_seo_h1           if self.h1.blank?
      #     self.title        = _obj.default_seo_title        if self.title.blank?
      #     self.keywords     = _obj.default_seo_keywords     if self.keywords.blank?
      #     self.description  = _obj.default_seo_description  if self.description.blank?
      #     self.title        = _obj.default_seo_og_title     if self.title.blank?
      #   end
      # end
      #
      # ############ rails_admin ##############
      # def self.rails_admin_add_fields
      #   [] #super
      # end
      #
      # def self.rails_admin_add_config(config)
      #   #super(config)
      # end
      #
      # def admin_can_user_defined_actions
      #   [].freeze
      # end
      # def admin_cannot_user_defined_actions
      #   [].freeze
      # end
      # def manager_can_user_defined_actions
      #   [].freeze
      # end
      # def manager_cannot_user_defined_actions
      #   [].freeze
      # end
      # def rails_admin_user_defined_visible_actions
      #   [].freeze
      # end

    end

  end
end
