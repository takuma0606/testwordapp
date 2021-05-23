class AddIndexToAdverb < ActiveRecord::Migration[5.2]
  def change
    add_index :adverbs, :deleted_at
  end
end
