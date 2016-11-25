require 'rails/generators'

module Hancock::Seo
  class SitemapGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    argument :host_arg, type: :string

    desc 'Hancock::Seo Sitemap config generator'
    def sitemap
      template 'sitemap.erb', "config/sitemap.rb"
    end

    def host
      _host = host_arg.blank? ? "http://host.domain" : host_arg
      if defined?(Addressable)
        Addressable::URI.heuristic_parse(_host).to_s
      else
        if _host =~ /^https?\:\/\//
          _host
        else
          _host = "http://#{_host}"
        end
      end
    end

  end
end
