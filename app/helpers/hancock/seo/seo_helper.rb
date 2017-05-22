module Hancock::Seo::SeoHelper

  def hancock_ym_counter_tag(counter_id)
    return nil if counter_id.blank?
    render partial: "hancock/seo/blocks/ym", locals: {counter_id: counter_id}
  end
  def hancock_ga_counter_tag(counter_id)
    return nil if counter_id.blank?
    render partial: "hancock/seo/blocks/ga", locals: {counter_id: counter_id}
  end
  def render_hancock_counters(opts = {})
    ret = []

    _cache_key = "ym_counter".freeze
    ym_counter = Rails.cache.fetch(_cache_key) do
      if Hancock::Seo.config.cache_support
        Hancock::Cache::Fragment.create_unless_exists(name: _cache_key, parents: hancock_cache_views_keys, parent_names: hancock_cache_views_keys)
        _cache_key = [_cache_key]
        _cache_key += hancock_cache_views_keys
      else
        _cache_key = [_cache_key]
      end
      _add_cache_key = opts.delete(:cache_key)
      _cache_key = [_cache_key, _add_cache_key].flatten if _add_cache_key

      _html = Settings.ym_counter_html(default: '', kind: :code, label: 'Yandex Метрика HTML-код'.freeze, cache_keys: _cache_key).strip
      unless _html.blank?
        _html
      else
        ym_counter_id = opts[:ym_counter_id] || Settings.ym_counter_id(default: '', kind: :string, label: 'Yandex Метрика ID'.freeze, cache_keys: _cache_key).strip
        ym_counter_id.blank? ? nil : hancock_ym_counter_tag(ym_counter_id)
      end
    end
    ret << ym_counter unless ym_counter.blank?

    _cache_key = "ga_counter".freeze
    ga_counter = Rails.cache.fetch(_cache_key) do
      if Hancock::Seo.config.cache_support
        Hancock::Cache::Fragment.create_unless_exists(name: _cache_key, parents: hancock_cache_views_keys, parent_names: hancock_cache_views_keys)
        _cache_key = [_cache_key]
        _cache_key += hancock_cache_views_keys
      else
        _cache_key = [_cache_key]
      end
      _add_cache_key = opts.delete(:cache_key)
      _cache_key = [_cache_key, _add_cache_key].flatten if _add_cache_key

      _html = Settings.ga_counter_html(default: '', kind: :code, label: 'Google Analitics HTML-код'.freeze, cache_keys: _cache_key).strip
      unless _html.blank?
        _html
      else
        ga_counter_id = opts[:ga_counter_id] || Settings.ga_counter_id(default: '', kind: :string, label: 'Google Analitics ID'.freeze, cache_keys: _cache_key).strip
        ga_counter_id.blank? ? nil : hancock_ga_counter_tag(ga_counter_id)
      end
    end
    ret << ga_counter unless ga_counter.blank?

    ret.join.html_safe
  end

  def og_tags_for(obj, alt_obj = nil)
    og_title        = ((obj.get_og_title.blank?       and alt_obj) ? alt_obj.get_og_title       : obj.get_og_title)
    og_description  = ((obj.get_og_description.blank? and alt_obj) ? alt_obj.get_og_description : obj.get_og_description)
    og_type         = ((obj.og_type.blank?            and alt_obj) ? alt_obj.og_type            : obj.og_type)
    og_url          = ((obj.og_url.blank?             and alt_obj) ? alt_obj.og_url             : obj.og_url)
    og_image        = ((obj.og_image.blank?           and alt_obj) ? alt_obj.og_image           : obj.og_image)

    og_url = try(:url_for, obj) rescue nil if og_url.blank?
    og_url = try(:url_for, alt_obj) rescue nil if og_url.blank? and alt_obj
    og_url = request.url if og_url.blank?

    if og_image.blank?
      og_image = Settings.default_og_image
      # og_image = og_image.file.url # we are already url
    end

    {
      title:        og_title,
      description:  og_description,
      type:         og_type,
      url:          og_url,
      image:        og_image
    }.reject { |_, v| v.blank? }
  end
  
end
