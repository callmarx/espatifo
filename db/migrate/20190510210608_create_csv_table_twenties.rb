class CreateCsvTableTwenties < ActiveRecord::Migration[5.2]
  def change
    create_table :csv_table_twenties do |t|
      t.references :project, foreign_key: true
      t.integer :total_lines
      t.jsonb :csv_content, null: false, default: '[]'

      t.timestamps
    end
  end
end
