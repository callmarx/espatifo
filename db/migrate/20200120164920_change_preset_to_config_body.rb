class ChangePresetToConfigBody < ActiveRecord::Migration[6.0]
  def change
    rename_column :reports, :preset, :config_body
  end
end
