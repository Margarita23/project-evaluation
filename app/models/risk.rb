class Risk < ApplicationRecord
  belongs_to :project
  
  validates :name, presence: true
  validates_uniqueness_of :name, scope: :project_id
  
end
