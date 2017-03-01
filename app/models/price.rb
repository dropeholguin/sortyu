class Price < ApplicationRecord
	monetize :value_cents, as: :value
end
