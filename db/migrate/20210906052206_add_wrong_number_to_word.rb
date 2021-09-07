class AddWrongNumberToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :wrong_number, :integer
  end
end
