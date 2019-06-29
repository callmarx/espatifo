class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.jsonb :csv_json
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
