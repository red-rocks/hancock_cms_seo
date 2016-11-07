module Hancock::Seo
  module Admin

    def self.seo_n_sitemap_block(is_active = false)
      Proc.new {
        active is_active
        label I18n.t('hancock.seo_n_sitemap')
        field :seo
        field :sitemap_data

        if block_given?
          yield self
        end
      }
    end

  end
end
