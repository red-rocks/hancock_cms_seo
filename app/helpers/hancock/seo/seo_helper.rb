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

    settings_method = (Hancock::Seo.config.cache_support ? :hancock_cache_settings : :hancock_settings)

    _cache_key = "ym_counter".freeze
    _html = send(settings_method, 'ym_counter_html', default: '', kind: :code, label: 'Yandex Метрика HTML-код'.freeze, settings_scope: Hancock::Seo::Seo.settings)
    ym_counter = unless _html.blank?
      _html
    else
      ym_counter_id = opts[:ym_counter_id] || send(settings_method, 'ym_counter_id', default: '', kind: :string, label: 'Yandex Метрика ID'.freeze, settings_scope: Hancock::Seo::Seo.settings).strip
      ym_counter_id.blank? ? nil : hancock_ym_counter_tag(ym_counter_id)
    end
    ret << ym_counter unless ym_counter.blank?

    _cache_key = "ga_counter".freeze
    _html = send(settings_method, 'ga_counter_html', default: '', kind: :code, label: 'Google Analitics HTML-код'.freeze, settings_scope: Hancock::Seo::Seo.settings)
    ga_counter = unless _html.blank?
      _html
    else
      ga_counter_id = opts[:ga_counter_id] || send(settings_method, 'ga_counter_id', default: '', kind: :string, label: 'Google Analitics ID'.freeze, settings_scope: Hancock::Seo::Seo.settings).strip
      ga_counter_id.blank? ? nil : hancock_ga_counter_tag(ga_counter_id)
    end
    ret << ga_counter unless ga_counter.blank?

    ret.join.html_safe
  end

  def og_tags_for(obj, alt_obj = nil)
    og_title        = ((obj.get_og_title.blank?       and alt_obj) ? alt_obj.get_og_title       : obj.get_og_title)
    og_description  = ((obj.get_og_description.blank? and alt_obj) ? alt_obj.get_og_description : obj.get_og_description)
    og_type         = ((obj.og_type.blank?            and alt_obj) ? alt_obj.og_type            : obj.og_type)
    og_url          = ((obj.og_url.blank?             and alt_obj) ? alt_obj.og_url             : obj.og_url)
    # og_image        = ((obj.og_image.blank?           and alt_obj) ? alt_obj.og_image           : obj.og_image)
    og_image_obj     = ((!obj.og_image?               and alt_obj) ? alt_obj                    : obj)

    if @clear_og_url
      og_url = "" unless og_url.blank?
    else
      og_url = try(:url_for, obj) rescue nil if og_url.blank?
      og_url = try(:url_for, alt_obj) rescue nil if og_url.blank? and alt_obj
      og_url = request.url if og_url.blank?
    end

    if !og_image_obj.og_image?
      og_image = Settings.default_og_image
      if og_image and !og_image.is_a?(String)
        og_image = og_image.url
      end
    else
      og_image = og_image_obj.get_og_image(:main)
    end
    # puts og_image.inspect

    {
      title:        og_title,
      description:  og_description,
      type:         og_type,
      url:          og_url,
      image:        og_image
    }.reject { |_, v| v.blank? }
  end
end
