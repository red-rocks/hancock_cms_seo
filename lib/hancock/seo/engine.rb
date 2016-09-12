module Hancock::Seo
  class Engine < ::Rails::Engine
    # isolate_namespace Hancock::Seo

    # rake_tasks do
    #   require File.expand_path('../tasks', __FILE__)
    # end

    initializer "hancock_cms_seo.counters_defaults" do
      # Write default email settings to DB so they can be changed.

      #temp
      begin
        if Settings and Settings.table_exists?
          _chache_key = "ym_counter"
          Settings.ym_counter_id(default: '', kind: :string, label: 'Yandex Метрика ID', cache_keys: _chache_key)
          Settings.ym_counter_html(default: '', kind: :html, label: 'Yandex Метрика HTML-код', cache_keys: _chache_key)

          _chache_key = "ga_counter"
          Settings.ga_counter_id(default: '', kind: :string, label: 'Google Analitics ID', cache_keys: _chache_key)
          Settings.ga_counter_html(default: '', kind: :html, label: 'Google Analitics HTML-код', cache_keys: _chache_key)
        end
      rescue
      end
    end

    config.after_initialize do
      # Write default email settings to DB so they can be changed.
      begin
        if Settings and Settings.table_exists?
          _chache_key = "ym_counter"
          Settings.ym_counter_id(default: '', kind: :string, label: 'Yandex Метрика ID', cache_keys: _chache_key)
          Settings.ym_counter_html(default: '', kind: :html, label: 'Yandex Метрика HTML-код', cache_keys: _chache_key)

          _chache_key = "ga_counter"
          Settings.ga_counter_id(default: '', kind: :string, label: 'Google Analitics ID', cache_keys: _chache_key)
          Settings.ga_counter_html(default: '', kind: :html, label: 'Google Analitics HTML-код', cache_keys: _chache_key)
        end
      rescue
      end
    end
  end
end
