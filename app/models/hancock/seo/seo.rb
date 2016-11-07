module Hancock::Seo
  if Hancock.active_record?
    class Seo < ActiveRecord::Base
    end
  end

  class Seo
    include Hancock::Seo::Models::Seo

    include Hancock::Seo::Decorators::Seo

    rails_admin(&Hancock::Seo::Admin::Seo.config(rails_admin_add_fields) { |config|
      rails_admin_add_config(config)
    })
  end
end
