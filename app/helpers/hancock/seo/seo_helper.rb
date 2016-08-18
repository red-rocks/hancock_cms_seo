module Hancock::Seo::SeoHelper

  def hancock_ym_counter_tag(counter_id)
    render partial: "hancock/seo/blocks/ym", locals: {counter_id: counter_id}
  end
  def hancock_ga_counter_tag(counter_id)
    render partial: "hancock/seo/blocks/ga", locals: {counter_id: counter_id}
  end
  def render_hancock_counters(opts = {})
    ret = []
    ym_counter_id = opts[:ym_counter_id] || Settings.ym_counter_id(default: '', kind: :string, title: 'Yandex Метрика ID').strip
    ga_counter_id = opts[:ga_counter_id] || Settings.ga_counter_id(default: '', kind: :string, title: 'Google Analitics ID').strip
    ret << hancock_ym_counter_tag(ym_counter_id) unless ym_counter_id.blank?
    ret << hancock_ga_counter_tag(ga_counter_id) unless ga_counter_id.blank?
    ret.join.html_safe
  end
end
