class CreateCosts < ActiveRecord::Migration[5.2]
  def change
    create_table :costs do |t|
      t.references :project, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
