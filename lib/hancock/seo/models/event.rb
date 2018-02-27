module Hancock::Seo
  module Models
    module Event
      extend ActiveSupport::Concern
      include Hancock::Model
      include Hancock::Enableable

      include Hancock::UserDefined

      if Hancock::Gallery.config.cache_support
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
          "window.yaCounter#{Settings.ym_counter_id}" unless Settings.ym_counter_id.blank?
        end
        add_insertion :ym_counter_object
        def ga_counter_object
          "window.ga" unless Settings.ga_counter_id.blank?
        end
        add_insertion :ga_counter_object

        acts_as_nested_set

        def function_name
          "hancock_seo_event_listener_#{self._id.hash.to_s.sub("-", "0")}"
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

        def self.rails_admin_navigation_icon
          'fa fa-check-square-o'.freeze
        end

      end

    end
  end
end
