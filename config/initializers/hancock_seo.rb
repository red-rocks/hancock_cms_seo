Hancock.rails_admin_configure do |config|
  if defined?(RailsAdminComments)
    config.action_visible_for :comments, 'Hancock::Seo::Seo'
    config.action_visible_for :comments, 'Hancock::Seo::SitemapData'
    config.action_visible_for :model_comments, 'Hancock::Seo::Seo'
    config.action_visible_for :model_comments, 'Hancock::Seo::SitemapData'
  end
end
