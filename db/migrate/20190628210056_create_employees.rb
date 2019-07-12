class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :second_name
      t.date :birthdate
      t.string :role
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
