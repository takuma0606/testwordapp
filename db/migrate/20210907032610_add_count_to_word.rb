class AddCountToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :count, :integer, default: 0
  end
end
