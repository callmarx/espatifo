class CreateUndigestedInputs < ActiveRecord::Migration[6.0]
  def change
    create_table :undigested_inputs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :data_set, null: false, foreign_key: true
      t.jsonb :columns
      t.jsonb :content

      t.timestamps
    end
  end
end
