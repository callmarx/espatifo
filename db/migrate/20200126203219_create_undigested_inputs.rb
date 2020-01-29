class CreateUndigestedInputs < ActiveRecord::Migration[6.0]
  def change
    create_table :undigested_inputs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :data_set, foreign_key: true
      t.string :name
      t.text :description
      t.jsonb :keys_info
      t.jsonb :content
      t.integer :status

      t.timestamps
    end
  end
end
