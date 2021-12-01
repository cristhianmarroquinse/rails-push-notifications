class Subscription < ApplicationRecord
    validates :email, presence: true
    validates :token, presence: true
end
