class Opportunity < ApplicationRecord
  belongs_to :project
  validates :name, presence: true, uniqueness: true
  
end
