module Hancock::Seo
  module Models
    module Mongoid
      module Event
        extend ActiveSupport::Concern
        included do
          index({enabled: 1},                     {background: true})

          field :name, type: String
          field :desc, type: String
          field :event_types, type: Array, default: []
          field :target_selector, type: String
          field :selector_function, type: String, default: -> { self.class::SELECTOR_FUNCTIONS.first }

          if Hancock::Seo.config.insertions_support
            user_defined_field :custom_listener_code, as: "listener_code_with_insertions"
          else
            field :custom_listener_code, type: String
          end
          def listener_code
            if custom_listener_code.blank?
              ret = []
              if ym_goal_data and !(ym_goal_data[:target] || ym_goal_data['target']).blank?
                ret << ym_goal_js_code
              end
              if !ga_event_data.blank?
                ret << ga_event_js_code
              end
              ret.join
            else
              if Hancock::Seo.config.insertions_support
                listener_code_with_insertions
              else
                custom_listener_code
              end
            end
          end

          field :ym_goal_data, type: Hash, default: {}
          def ym_goal_data_formatted
            return @ym_goal_data_formatted if @ym_goal_data_formatted
            ret = {}
            ym_goal_data.keys.select { |k| k.to_s == "target" or k.to_s =~ /^params_.+/}.each do |k|
              ret[k.to_s] = ym_goal_data[k]
            end
            @ym_goal_data_formatted = ret
          end
          def ym_goal_js_code
            unless ym_counter_object.blank?
              @ym_goal_js_code ||= "#{ym_counter_object}.reachGoal('#{ym_goal_data_formatted['target']}', #{(ym_goal_data_formatted['params'] || {}).to_json});"
            end
          end
          add_insertion :ym_goal_data_formatted
          add_insertion :ym_goal_js_code

          field :ga_event_data, type: Hash, default: {}
          def ga_event_data_formatted
            return @ga_event_data_formatted if @ga_event_data_formatted
            ret = {'hitType': 'event'}
            ym_goal_data.keys.select { |k| ['hitType', 'eventCategory', 'eventAction', 'eventLabel', 'eventValue'].include?(k.to_s) }.each do |k|
              ret[k.to_s] = ga_event_data[k]
            end
            @ga_event_data_formatted = ret
          end
          def ga_event_js_code
            unless ga_counter_object.blank?
              @ga_event_js_code ||= "#{ga_counter_object}('send', #{(ga_event_data_formatted || {'hitType': 'event'}).to_json});"
            end
          end
          add_insertion :ga_event_data_formatted
          add_insertion :ga_event_js_code


          scope :sorted, -> { order_by([:lft, :asc]) }
        end
      end
    end
  end
end
