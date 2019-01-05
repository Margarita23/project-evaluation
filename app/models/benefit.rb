class Benefit < ApplicationRecord
  belongs_to :project
  
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :project_id
  
end
