module Hancock::Seo
  if Hancock.active_record?
    class Event < ActiveRecord::Base
    end
  end

  class Event
    include Hancock::Seo::Models::Event

    include Hancock::Seo::Decorators::Event

    rails_admin(&Hancock::Seo::Admin::Event.config(rails_admin_add_fields) { |config|
      rails_admin_add_config(config)
    })
  end
end
