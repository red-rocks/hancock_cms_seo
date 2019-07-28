Hancock.rails_admin_configure do |config|
  config.action_visible_for :sitemap
  config.action_visible_for :sitemap_for_model, 'Hancock::Seo::SitemapData'

  config.action_visible_for :robots_txt
  config.action_visible_for :robots_txt_for_model, 'Hancock::Seo::Seo'
end
