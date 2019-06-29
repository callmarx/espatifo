class CreateOperationals < ActiveRecord::Migration[5.2]
  def change
    create_table :operationals do |t|
      t.string :first_name
      t.string :second_name
      t.date :birthdate

      t.timestamps
    end
  end
end
