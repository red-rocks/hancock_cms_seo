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

          field :listener_code, type: String

          scope :sorted, -> { order_by([:lft, :asc]) }
        end
      end
    end
  end
end
