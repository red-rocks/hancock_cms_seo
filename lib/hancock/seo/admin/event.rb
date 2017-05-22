module Hancock::Seo
  module Admin
    module Event
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
            # scopes [nil, :enabled, :with_empty_objects]
            scopes [nil, :enabled]
          end

          label I18n.t('hancock.seo.event')
          field :enabled, :toggle
          field :name
          field :desc, :text
          field :event_types, :hancock_array do
            enum do
              Hancock::Seo::Event::EVENT_TYPES
            end
            pretty_value do
              bindings[:object] and bindings[:object].event_type_str
            end
            searchable true
          end
          field :target_selector, :text do
            searchable true
          end
          field :selector_function, :hancock_enum do
            enum do
              Hancock::Seo::Event::SELECTOR_FUNCTIONS
            end
            searchable true
          end
          field :listener_code, :code_mirror do
            config do
              {
                mode: 'jsx',
                theme: 'night',
              }
            end
            assets do
              {
                mode: '/assets/codemirror/modes/jsx.js',
                theme: '/assets/codemirror/themes/night.css',
              }
            end
            searchable true
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
