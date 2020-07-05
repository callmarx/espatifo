class CreateDataInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :data_infos do |t|
      t.jsonb :chart_info
      t.jsonb :min_max
      t.references :data_portion, polymorphic: true, null: false

      t.timestamps
    end
  end
end
