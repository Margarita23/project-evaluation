class Project < ApplicationRecord
  belongs_to :user
  has_many :opportunities, dependent: :destroy
  has_many :benefits, dependent: :destroy
  has_many :costs, dependent: :destroy
  has_many :risks, dependent: :destroy
  
  validates :name, presence: true
  validates_uniqueness_of :name, :scope => :user_id
  
end
