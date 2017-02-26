module Hancock::Seo::Sitemapable
  extend ActiveSupport::Concern

  included do
    include Hancock::Seo::SitemapDataField
  end
end
