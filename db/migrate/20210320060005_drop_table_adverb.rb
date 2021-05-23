class DropTableAdverb < ActiveRecord::Migration[5.2]
  def change
    drop_table :list_adverbs
    drop_table :result_adverbs
  end
end
