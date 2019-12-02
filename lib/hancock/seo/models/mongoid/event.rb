module Hancock::Seo
  module Models
    module Mongoid
      module Event
        extend ActiveSupport::Concern
        included do
          index({enabled: 1}, {background: true})

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
            unless custom_listener_code.blank?
              if Hancock::Seo.config.insertions_support
                return listener_code_with_insertions
              else
                return custom_listener_code
              end
            end

            ret = []
            if ym_goal_data and !(ym_goal_data[:target] || ym_goal_data['target']).blank?
              ret << ym_goal_debug_js_code << ym_goal_js_code
            end
            if !ga_event_data.blank?
              if !(ga_event_data[:eventCategory] || ga_event_data['eventCategory']).blank?
                if !(ga_event_data[:eventAction] || ga_event_data['eventAction']).blank?
                  ret << ga_event_debug_js_code << ga_event_js_code
                end
              end
            end
            if !gtag_action.blank?
              ret << gtag_event_debug_js_code << gtag_event_js_code
            end
            ret.join
          end

          field :ym_goal_data, type: Hash, default: {target: ""}
          def ym_goal_data_formatted
            return @ym_goal_data_formatted if @ym_goal_data_formatted
            ret = {}
            ym_goal_data.keys.select { |k| k.to_s == "target" or k.to_s =~ /^params_.+/}.each do |k|
              ret[k.to_s] = ym_goal_data[k] if !ym_goal_data[k].blank? and !ym_goal_data[k].strip.blank?
            end
            @ym_goal_data_formatted = ret
          end
          def ym_goal_js_code
            unless ym_counter_object.blank?
              @ym_goal_js_code ||= "#{ym_counter_object}.reachGoal('#{ym_goal_data_formatted['target']}', #{(ym_goal_data_formatted['params'] || {}).to_json});#{ym_goal_debug_js_code}".strip
            end
          end
          def ym_goal_debug_js_code
            "alert('YM event: #{ym_goal_data_formatted}');" unless Rails.env.production?
          end
          add_insertion :ym_goal_data_formatted
          add_insertion :ym_goal_js_code


          field :ga_event_data, type: Hash, default: {'hitType' => 'event', 'eventCategory' => '', 'eventAction' => '', 'eventLabel' => '', 'eventValue' => ''}
          def ga_event_data_formatted
            return @ga_event_data_formatted if @ga_event_data_formatted
            ret = {'hitType' => 'event'}
            ga_event_data.keys.select { |k| ['hitType', 'eventCategory', 'eventAction', 'eventLabel', 'eventValue'].include?(k.to_s) }.each do |k|
              ret[k.to_s] = ga_event_data[k] if !ga_event_data[k].blank? and !ga_event_data[k].strip.blank?              
            end
            ret['eventValue'] = ret['eventValue'].to_i if ret['eventValue']
            @ga_event_data_formatted = ret
          end
          def ga_event_js_code
            unless ga_counter_object.blank?
              @ga_event_js_code ||= "#{ga_counter_object}('send', #{(ga_event_data_formatted || {'hitType': 'event'}).to_json});"
            end
          end
          def ga_event_debug_js_code
            "alert('GA event: #{ga_event_data_formatted.to_json}');" unless Rails.env.production?
          end
          add_insertion :ga_event_data_formatted
          add_insertion :ga_event_js_code



          field :gtag_action, type: String, default: ""
          field :gtag_event_data, type: Hash, default: {}
          def gtag_event_data_formatted
            return @gtag_event_data_formatted if @gtag_event_data_formatted
            ret = {}
            ga_event_data.each do |k, v|
              ret[k.to_s] = v if !v.blank? and !v.strip.blank?              
            end
            @gtag_event_data_formatted = ret
          end
          def gtag_event_js_code
            if !gtag_counter_object.blank? and !gtag_action.blank?
              @gtag_event_js_code ||= "#{gtag_counter_object}('event', '#{gtag_action}',#{(gtag_event_data_formatted || {}).to_json});"
            end
          end
          def gtag_event_debug_js_code
            "alert('GTag event: #{gtag_event_data_formatted.to_json}');" unless Rails.env.production?
          end
          add_insertion :gtag_event_data_formatted
          add_insertion :gtag_event_js_code


          scope :sorted, -> { order_by([:lft, :asc]) }
        end
      end
    end
  end
end
