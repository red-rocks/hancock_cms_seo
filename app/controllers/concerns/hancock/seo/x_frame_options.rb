module Hancock::Seo::XFrameOptions
  extend ActiveSupport::Concern

  included do
    def clear_x_frame_options
      begin
        if x_frame_options_referer_regexp and request.referer =~ x_frame_options_referer_regexp
          response.headers.delete('X-Frame-Options')
        else
          if defined?(Addressable)
            _domain = Addressable::URI.parse(request.referer).domain
          else
            _domain = URI.parse(request.referer).host
          end

          if base_site_host.is_a?(Regexp)
            response.headers.delete('X-Frame-Options') if _domain =~ base_site_host
          else
            response.headers.delete('X-Frame-Options') if _domain == base_site_host
          end
        end
      rescue
      end
    end
  end

  class_methods do
    def clear_x_frame_options
      after_action :clear_x_frame_options
    end
  end

  protected
  def x_frame_options_referer_regexp
    # /^https?:\/\/([^\/]+metrika.*yandex.(ru|ua|com|com.tr|by|kz)|([^\/]+.)?webvisor.com)\//
    /^https?\:\/\/([^\/]*metrika.*yandex\.(ru|ua|com|com\.tr|by|kz)|([^\/]+\.)?webvisor\.com)\//i
  end
  def base_site_host
    request.domain
  end

end
