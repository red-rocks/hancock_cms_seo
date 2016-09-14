module Hancock::Seo::SitemapDataField
  extend ActiveSupport::Concern
  FIELDS = [:sitemap_show, :sitemap_lastmod, :sitemap_changefreq, :sitemap_priority]

  included do
    has_one :sitemap_data, as: :sitemap_data_field, autosave: true, class_name: "Hancock::Seo::SitemapData"
    accepts_nested_attributes_for :sitemap_data

    delegate *FIELDS, to: :sitemap_data
    delegate *(FIELDS.map {|f| "#{f}=".to_sym }), to: :sitemap_data

    alias sitemap_data_without_build sitemap_data
    def sitemap_data
      sitemap_data_without_build || build_sitemap_data
    end

    def default_sitemap_changefreq
      'weekly'
    end
    def default_sitemap_priority
      0.8
    end

    def to_sitemap(sitemap)
      _sitemap_data = self.sitemap_data
      _lastmod = _sitemap_data.sitemap_lastmod.to_date  unless _sitemap_data.sitemap_lastmod.nil?
      _lastmod = self.updated_at.to_date                unless self.updated_at.nil?        if _lastmod.nil?
      _lastmod = self.created_at.to_date                unless self.created_at.nil?        if _lastmod.nil?

      sitemap.add sitemap.url_for(i),
          :lastmod      => _lastmod,
          :changefreq   => "#{_sitemap_data.sitemap_changefreq.blank? ? self.default_changefreq       : _sitemap_data.sitemap_changefreq}",
          :priority     => (_sitemap_data.sitemap_priority.nil?       ? self.default_sitemap_priority : _sitemap_data.sitemap_priority)
    end

  end
end
