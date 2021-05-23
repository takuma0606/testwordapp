class RemoveIndexWordsDeletedAt < ActiveRecord::Migration[5.2]
  def change
    remove_index :words, :deleted_at
  end
end
