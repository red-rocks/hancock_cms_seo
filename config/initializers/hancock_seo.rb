Hancock.rails_admin_configure do |config|
  config.action_visible_for :sitemap, Proc.new { false }
  config.action_visible_for :hancock_sitemap_generate, 'Hancock::Cache::Fragment'
end
