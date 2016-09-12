module Hancock::Seo::SeoHelper

  def hancock_ym_counter_tag(counter_id)
    render partial: "hancock/seo/blocks/ym", locals: {counter_id: counter_id}
  end
  def hancock_ga_counter_tag(counter_id)
    render partial: "hancock/seo/blocks/ga", locals: {counter_id: counter_id}
  end
  def render_hancock_counters(opts = {})
    ret = []

    _cache_key = "ym_counter"
    ym_counter = Rails.cache.fetch(_cache_key) do
      ym_counter_id = opts[:ym_counter_id] || Settings.ym_counter_id(default: '', kind: :string, label: 'Yandex Метрика ID', cache_keys: _cache_key).strip
      if ym_counter_id.blank?
        Settings.ym_counter_html(default: '', kind: :code, label: 'Yandex Метрика HTML-код', cache_keys: _cache_key).strip
      else
        hancock_ym_counter_tag(ym_counter_id)
      end
    end
    ret << ym_counter unless ym_counter.blank?

    _cache_key = "ga_counter"
    ga_counter = Rails.cache.fetch(_cache_key) do
      ga_counter_id = opts[:ga_counter_id] || Settings.ga_counter_id(default: '', kind: :string, label: 'Google Analitics ID', cache_keys: _cache_key).strip
      if ga_counter_id.blank?
        Settings.ga_counter_html(default: '', kind: :code, label: 'Google Analitics HTML-код', cache_keys: _cache_key).strip
      else
        hancock_ga_counter_tag(ga_counter_id)
      end
    end
    ret << ga_counter unless ga_counter.blank?

    ret.join.html_safe
  end
end
