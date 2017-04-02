module Hancock::Seo
  module Admin
    module SitemapData
      def self.config(nav_label = nil, fields = {})
        if nav_label.is_a?(Hash)
          nav_label, fields = nav_label[:nav_label], nav_label
        elsif nav_label.is_a?(Array)
          nav_label, fields = nil, nav_label
        end

        Proc.new {
          navigation_label(!nav_label.blank? ? nav_label : 'SEO')

          list do
            # scopes [nil, :enabled, :disconnected]
            scopes [nil, :enabled, :with_empty_objects]
          end

          label I18n.t('hancock.seo.sitemap_data')
          field :sitemap_data_field do
            read_only true
            pretty_value do
              v = bindings[:view]
              [value].flatten.select(&:present?).collect do |associated|
                amc = polymorphic? ? RailsAdmin.config(associated) : associated_model_config # perf optimization for non-polymorphic associations
                am = amc.abstract_model
                wording = associated.send(amc.object_label_method)
                wording = "#{wording} (#{am.model.model_name.human})"
                can_see = !am.embedded? && (show_action = v.action(:show, am, associated))
                can_see ? v.link_to(wording, v.url_for(action: show_action.action_name, model_name: am.to_param, id: associated.id), class: 'pjax') : ERB::Util.html_escape(wording)
              end.to_sentence.html_safe
            end
          end
          # field :disconnected, :toggle
          field :sitemap_show, :toggle
          field :sitemap_lastmod
          field :sitemap_changefreq, :enum do
            enum do
              Hancock::Seo::SitemapData::SITEMAP_CHANGEFREQ_ARRAY
            end
          end
          field :sitemap_priority

          Hancock::RailsAdminGroupPatch::hancock_cms_group(self, fields)

          if block_given?
            yield self
          end
        }
      end
    end
  end
end
