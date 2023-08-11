class AddFavoriteToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :favorite_count, :integer, default: 0
    add_column :words, :forgot_count, :integer, default: 0
  end
end
