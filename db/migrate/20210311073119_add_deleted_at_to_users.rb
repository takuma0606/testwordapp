class AddDeletedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :deleted_at, :datetime
    add_index :words, :deleted_at
  end
end
