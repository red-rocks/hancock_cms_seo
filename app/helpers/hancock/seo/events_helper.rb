module Hancock::Seo::EventsHelper

  def render_seo_events
    Hancock::Seo::Event.enabled.sorted.to_a.map { |e|
      code  = []
      code << "(function(){"
      code << "function #{e.function_name}(e){#{e.listener_code}};"
      e.event_types.each do |type|
        next if type.blank? or type.strip.blank?
        code << "document.#{e.selector_function}('#{e.target_selector}').addEventListener('#{type}', #{e.function_name});"
      end
      code << "})();"
      javascript_tag code.join
    }.join.html_safe
  end

end
