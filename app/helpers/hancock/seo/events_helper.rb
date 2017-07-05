module Hancock::Seo::EventsHelper

  def render_seo_events_functions
    Hancock::Seo::Event.enabled.sorted.to_a.map do |e|
      code  = []
      function_name = "window.#{e.function_name}"
      code << "#{function_name} || (#{function_name} = function(e){#{e.listener_code}});"
      # code << "function #{e.function_name}(e){#{e.listener_code_with_insertions}};"
      e.event_types.each do |type|
        next if type.blank? or type.strip.blank?
        add_event_listener_code = "addEventListener('#{type}', window.#{e.function_name})"
        if e.target_selector.blank?
          event_elem = "document"
          code << "#{event_elem}.#{add_event_listener_code};"
        else
          event_elem = "document.#{e.selector_function}('#{e.target_selector}')"
          code << case e.selector_function
          when 'querySelectorAll'
            "#{event_elem}.forEach(function(){this.#{add_event_listener_code};});"
          when 'querySelector'
            "((elem = #{event_elem}) && elem.#{add_event_listener_code});"
          else
            "((elem = #{event_elem}) && elem.#{add_event_listener_code});"
          end
        end
      end
      code
    end.join.html_safe
  end

  def render_seo_events_tags
    code  = []
    reset_events_function_name = Hancock::Seo.config.reset_events_function_name
    code << "#{reset_events_function_name} || (#{reset_events_function_name} = function(){"
    code << render_seo_events_functions
    # Hancock::Seo::Event.enabled.sorted.to_a.each do |e|
    #   function_name = "window.#{e.function_name}"
    #   code << "#{function_name} || (#{function_name}= function(e){#{e.listener_code}});"
    #   # code << "function #{e.function_name}(e){#{e.listener_code_with_insertions}};"
    #   e.event_types.each do |type|
    #     next if type.blank? or type.strip.blank?
    #     add_event_listener_code = "addEventListener('#{type}', #{e.function_name});"
    #     if e.target_selector.blank?
    #       event_elem = "document"
    #       code << "#{event_elem}.#{add_event_listener_code}"
    #     else
    #       event_elem = "document.#{e.selector_function}('#{e.target_selector}')"
    #       code << case e.selector_function
    #       when 'querySelectorAll'
    #         "#{event_elem}.forEach(function(){this.#{add_event_listener_code}});"
    #       when 'querySelector'
    #         "#{event_elem}.#{add_event_listener_code}"
    #       else
    #         "#{event_elem}.#{add_event_listener_code}"
    #       end
    #     end
    #   end
    # end
    code << "}); #{reset_events_function_name}();"
    javascript_tag code.join.html_safe, defer: true
  end

end
