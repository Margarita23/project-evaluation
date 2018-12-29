class CreateRisks < ActiveRecord::Migration[5.2]
  def change
    create_table :risks do |t|
      t.references :project, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
