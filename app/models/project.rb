class Project < ApplicationRecord
  belongs_to :user
  has_many :opportunities, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  
end
