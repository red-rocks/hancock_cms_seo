module Hancock::Seo
  module Admin
    module Seo
      def self.config(nav_label = nil, fields = {})
        if nav_label.is_a?(Hash)
          nav_label, fields = nav_label[:nav_label], nav_label
        elsif nav_label.is_a?(Array)
          nav_label, fields = nil, nav_label
        end

        Proc.new {
          navigation_icon('mdi mdi-magnify')
          navigation_label(!nav_label.blank? ? nav_label : 'SEO')

          list do
            # scopes [nil, :enabled, :disconnected]
            scopes [nil, :enabled, :with_empty_objects]
          end

          label I18n.t('hancock.seo.seo')
          field :seoable do
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
          field :h1, :string do
            searchable true
          end
          field :title, :string do
            searchable true
          end
          field :author, :string do
            searchable true
          end
          field :keywords, :text do
            searchable true
          end
          field :description, :text do
            searchable true
          end
          field :robots, :string do
            searchable true
          end

          field :og_title, :string do
            searchable true
          end

          if Hancock::Seo.config.gallery_support
            field :og_image, :hancock_image
          end
          field :og_description, :text do
            searchable true
          end
          field :og_url, :string do
            searchable true
          end
          field :og_image, :hancock_image
          field :og_type, :hancock_enum_with_custom do
            enum do
              Hancock::Seo::Seo::OG_TYPES
            end
          end

          if Hancock::Seo.config.cache_support
            group :caching, &Hancock::Cache::Admin.caching_block
          end

          Hancock::RailsAdminGroupPatch::hancock_cms_group(self, fields)

          if block_given?
            yield self
          end
        }
      end
    end
  end
end
