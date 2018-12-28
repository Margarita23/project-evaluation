class Opportunity < ApplicationRecord
  belongs_to :project
  #validates :name, presence: true, uniqueness: true
  #rails g migration add_column :opportunities, :name, :string, :default => "Новая возможность"
  
end
