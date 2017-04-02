module Hancock::Seo
  module Models
    module Mongoid
      module SitemapData
        extend ActiveSupport::Concern

        included do
          index({sitemap_data_field_id: 1, sitemap_data_field_type: 1}, {background: true})
          index({enabled: 1, sitemap_show: 1},                          {background: true})
          # index({disconnected: 1},                                      {background: true})
          #
          # field :disconnected, typee: Boolean, default: -> {
          #   !sitemap_data_field
          # }
          # scope :disconnected, -> {
          #   where(disconnected: true)
          # }

          field :sitemap_show,        type: Boolean, default: true
          field :sitemap_lastmod,     type: DateTime
          field :sitemap_changefreq,  type: String,   default: 'daily'
          field :sitemap_priority,    type: Float

          scope :sitemap_show,    -> { where(sitemap_show: true) }
          scope :for_sitemap,     -> { sitemap_show }
          scope :show_in_sitemap, -> { sitemap_show }
        end

      end
    end
  end
end
