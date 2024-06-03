class SupportRequest < ApplicationRecord
  belongs_to :intervention, optional: true
end
