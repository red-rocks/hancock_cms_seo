module Hancock::Seo
  module Models
    module Mongoid
      module Seo
        extend ActiveSupport::Concern
        included do
          index({seoable_id: 1, seoable_type: 1})
          index({enabled: 1})


          # field :name, type: String, localize: Hancock::Seo.config.localize
          field :h1, type: String, localize: Hancock::Seo.config.localize

          field :title, type: String, localize: Hancock::Seo.config.localize
          field :author, type: String, localize: Hancock::Seo.config.localize
          field :keywords, type: String, localize: Hancock::Seo.config.localize
          field :description, type: String, localize: Hancock::Seo.config.localize
          field :robots, type: String, localize: Hancock::Seo.config.localize

          field :og_title, type: String, localize: Hancock::Seo.config.localize
        end
      end
    end
  end
end
