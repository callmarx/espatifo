class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description, null: false
      # t.jsonb :csv_table00001_10000, null: false, default: '{}'
      # t.jsonb :csv_table10001_20000, null: false, default: '{}'
      # t.jsonb :csv_table20001_30000, null: false, default: '{}'
      # t.jsonb :csv_table30001_40000, null: false, default: '{}'
      # t.jsonb :csv_table40001_50000, null: false, default: '{}'
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
