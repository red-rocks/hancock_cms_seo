module Hancock::Seo
  module Models
    module Event
      extend ActiveSupport::Concern
      include Hancock::Model
      include Hancock::Enableable

      include Hancock::UserDefined

      if Hancock::Seo.config.cache_support
        include Hancock::Cache::Cacheable
      end

      include Hancock::Seo.orm_specific('Event')

      EVENT_TYPES = %w(
        click
        submit
      ).freeze

      SELECTOR_FUNCTIONS = %w(
        querySelector
        querySelectorAll
      ).freeze

      included do
        def ym_counter_object
          "window.yaCounter#{Hancock::Seo::Seo.settings.ym_counter_id}" unless Hancock::Seo::Seo.settings.ym_counter_id.blank?
        end
        add_insertion :ym_counter_object

        def ga_counter_object
          "window.ga" unless Hancock::Seo::Seo.settings.ga_counter_id.blank?
        end
        add_insertion :ga_counter_object

        def gtag_counter_object
          "window.gtag" unless Hancock::Seo::Seo.settings.gtag_counter_id.blank?
        end
        add_insertion :gtag_counter_object


        acts_as_nested_set


        def self.init_functions_pool
          "window.#{function_pool_name} = {};"
        end
        def self.function_pool_name
          "hancock_seo_event_listeners"
        end
        def function_name
          "#{self.class.function_pool_name}.e#{self._id.hash.to_s.sub("-", "0")}"
        end
        add_insertion :function_name

        def event_types=(val)
          self[:event_types] = val.reject { |t| t.blank? or t.strip.blank? }
        end

        def event_types_str(joiner = ", ")
          self.event_types.join(joiner)
        end
        add_insertion :event_types_str

        # def self.admin_can_default_actions
        #   [:show, :read, :edit, :update].freeze
        # end
        # def self.manager_can_default_actions
        #   [:show, :read, :edit, :update].freeze
        # end
        def self.admin_cannot_actions
          [].freeze
        end
        def self.manager_cannot_actions
          [].freeze
        end

        def self.rails_admin_name_synonyms
          rus = [
            "яндекс метрика",
            "гугл аналитика",
            "гугл тэг менеджер",
            "гугл таг менеджер",
            "гтаг гтэг гуглтэг гуглтаг"
          ]
          eng = [
            "yandex metrics",
            "google analytics",
            "google tag manager",
            "gtag"
          ]
          (rus + eng).join(",").freeze
        end
    

        def self.manager_can_add_actions
          ret = [:nested_set]
          # ret += [:multiple_file_upload, :sort_embedded] if Hancock::Seo.mongoid?
          ret << :model_settings if Hancock::Seo.config.model_settings_support
          # ret << :model_accesses if Hancock::Seo.config.user_abilities_support
          ret += [:comments, :model_comments] if Hancock::Seo.config.ra_comments_support
          ret.freeze
        end
        def self.rails_admin_add_visible_actions
          ret = [:nested_set]
          # ret += [:multiple_file_upload, :sort_embedded] if Hancock::Seo.mongoid?
          ret << :model_settings if Hancock::Seo.config.model_settings_support
          ret << :model_accesses if Hancock::Seo.config.user_abilities_support
          ret += [:comments, :model_comments] if Hancock::Seo.config.ra_comments_support
          ret.freeze
        end

      end

    end
  end
end
