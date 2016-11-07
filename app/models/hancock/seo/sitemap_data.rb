module Hancock::Seo
  if Hancock.active_record?
    class SitemapData < ActiveRecord::Base
    end
  end

  class SitemapData
    include Hancock::Seo::Models::SitemapData

    include Hancock::Seo::Decorators::SitemapData

    rails_admin(&Hancock::Seo::Admin::SitemapData.config(rails_admin_add_fields) { |config|
      rails_admin_add_config(config)
    })
  end
end
