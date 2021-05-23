class AddColumnToWordFavorite < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :favorite, :boolean, default: false, null: false
  end
end
