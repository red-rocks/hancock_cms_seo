module Hancock::Seo
  module Admin

    def self.seo_n_sitemap_block(is_active = false, options = {})
      if is_active.is_a?(Hash)
        is_active, options = (is_active[:active] || false), is_active
      end

      Proc.new {
        active is_active
        label options[:label] || I18n.t('hancock.seo_n_sitemap')
        field :seo
        field :sitemap_data

        Hancock::RailsAdminGroupPatch::hancock_cms_group(self, options[:fields] || {})

        if block_given?
          yield self
        end
      }
    end

  end
end
