module Hancock::Seo
  module Models
    module Mongoid
      module Event
        extend ActiveSupport::Concern
        included do
          index({enabled: 1},                     {background: true})

          field :name, type: String
          field :desc, type: String
          field :event_types, type: Array, default: []
          field :target_selector, type: String
          field :selector_function, type: String, default: -> { self.class::SELECTOR_FUNCTIONS.first }

          if Hancock::Seo.config.insertions_support
            user_defined_field :listener_code, as: "listener_code_with_insertions"
          else
            field :listener_code, type: String
          end

          scope :sorted, -> { order_by([:lft, :asc]) }
        end
      end
    end
  end
end
