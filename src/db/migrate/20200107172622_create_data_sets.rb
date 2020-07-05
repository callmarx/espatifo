class CreateDataSets < ActiveRecord::Migration[6.0]
  def change
    create_table :data_sets do |t|
      t.string :name
      t.text :description
      t.jsonb :keys_info

      t.timestamps
    end
  end
end
