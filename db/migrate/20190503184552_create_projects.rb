class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.jsonb :csv_table, null: false, default: '{}'
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
