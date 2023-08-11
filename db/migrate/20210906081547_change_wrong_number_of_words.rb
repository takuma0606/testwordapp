class ChangeWrongNumberOfWords < ActiveRecord::Migration[5.2]
  def up
    change_column :words, :wrong_number, :integer, default: 0
  end
  
  def down
    change_column :words, :wrong_number, :integer
  end
end
