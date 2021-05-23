class AddColumnToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :part_of_speech, :string
  end
end
