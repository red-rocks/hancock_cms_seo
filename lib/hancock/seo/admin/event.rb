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
              (bindings[:object] and bindings[:object].event_types_str)
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
          field :ym_goal_data, :hancock_hash do
            editor_type :full
            help do
              link = bindings[:view].link_to "Помощь", "https://yandex.ru/support/metrika/objects/reachgoal.xml", target: :_blank
              "target, params_param1, params_param2 => {id: id, params: {param1: param1, param2: param2}}<br>#{link}".html_safe
            end
          end
          field :ga_event_data, :hancock_hash do
            editor_type :full
            help do
              link = bindings[:view].link_to "Помощь", "https://developers.google.com/analytics/devguides/collection/analyticsjs/events?hl=ru", target: :_blank
              "hitType('event' by default), eventCategory, eventAction, eventLabel, eventValue<br>#{link}".html_safe
            end
          end
          field :custom_listener_code, :code_mirror do
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
            help do
              ret = []
              ret << "e - текущее событие внутри коллбека."
              if @abstract_model.model.respond_to?(:insertions_fields)
                if @abstract_model.model.insertions_fields.include?(name)
                  ret << 'Можно использовать вставки.'
                end
              end
              ret.join("<br>").html_safe
            end
            searchable true
          end

          if Hancock::Seo.config.insertions_support
            group :insertions, &Hancock::Admin.insertions_block
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
