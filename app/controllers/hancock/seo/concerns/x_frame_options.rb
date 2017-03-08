module Hancock::Seo::XFrameOptions
  extend ActiveSupport::Concern

  included do
    def clear_x_frame_options
      response.headers.delete('X-Frame-Options') if x_frame_options_referer_regexp and request.referer =~ x_frame_options_referer_regexp
    end
  end

  class_methods do
    def clear_x_frame_options
      after_action :clear_x_frame_options
    end
  end

  protected
  def x_frame_options_referer_regexp
    /^https?:\/\/([^\/]+metrika.*yandex.(ru|ua|com|com.tr|by|kz)|([^\/]+.)?webvisor.com)\//
  end

end
