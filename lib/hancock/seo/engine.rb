module Hancock::Seo
  class Engine < ::Rails::Engine
    # isolate_namespace Hancock::Seo

    # rake_tasks do
    #   require File.expand_path('../tasks', __FILE__)
    # end

    # initializer "hancock_cms_seo.counters_defaults" do
    #   # Write default email settings to DB so they can be changed.
    #
    #   #temp
    #   begin
    #     if Settings and Settings.table_exists?
    #       _cache_key = "ym_counter".freeze
    #       Settings.ym_counter_id(default: '', kind: :string, label: 'Yandex Метрика ID'.freeze, cache_keys: _cache_key)
    #       Settings.ym_counter_html(default: '', kind: :html, label: 'Yandex Метрика HTML-код'.freeze, cache_keys: _cache_key)
    #
    #       _cache_key = "ga_counter".freeze
    #       Settings.ga_counter_id(default: '', kind: :string, label: 'Google Analitics ID'.freeze, cache_keys: _cache_key)
    #       Settings.ga_counter_html(default: '', kind: :html, label: 'Google Analitics HTML-код'.freeze, cache_keys: _cache_key)
    #     end
    #   rescue
    #   end
    # end

    config.after_initialize do
      puts 'Hancock::Seo after_initialize'
      # Write default email settings to DB so they can be changed.
      begin
        if Settings and Settings.table_exists?
          _cache_key = "ym_counter".freeze
          Settings.ym_counter_id(default: '', kind: :string, label: 'Yandex Метрика ID'.freeze, cache_keys: _cache_key) unless RailsAdminSettings::Setting.ns("main").where(key: "ym_counter_id").exists?
          Settings.ym_counter_html(default: '', kind: :html, label: 'Yandex Метрика HTML-код'.freeze, cache_keys: _cache_key) unless RailsAdminSettings::Setting.ns("main").where(key: "ym_counter_html").exists?

          _cache_key = "ga_counter".freeze
          Settings.ga_counter_id(default: '', kind: :string, label: 'Google Analitics ID'.freeze, cache_keys: _cache_key) unless RailsAdminSettings::Setting.ns("main").where(key: "ga_counter_id").exists?
          Settings.ga_counter_html(default: '', kind: :html, label: 'Google Analitics HTML-код'.freeze, cache_keys: _cache_key) unless RailsAdminSettings::Setting.ns("main").where(key: "ga_counter_html").exists?
        end
      rescue
      end
    end

  end
end
