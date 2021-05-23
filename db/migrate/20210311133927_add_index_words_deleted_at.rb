class AddIndexWordsDeletedAt < ActiveRecord::Migration[5.2]
  def change
    add_index :words, :deleted_at
  end
end
