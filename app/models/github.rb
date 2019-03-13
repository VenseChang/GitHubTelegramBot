class Github < ApplicationRecord
  belongs_to :user

  has_many :repos
end
