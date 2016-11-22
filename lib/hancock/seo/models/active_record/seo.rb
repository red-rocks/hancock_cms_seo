module Hancock::Seo
  module Models
    module ActiveRecord
      module Seo
        extend ActiveSupport::Concern
        included do
          if Hancock::Seo.config.localize
            translates :h1, :title, :keywords, :description, :og_title, :author
          end
        end
      end
    end
  end
end
