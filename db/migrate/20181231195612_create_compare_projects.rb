class CreateCompareProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :compare_projects do |t|

      t.timestamps
    end
  end
end
