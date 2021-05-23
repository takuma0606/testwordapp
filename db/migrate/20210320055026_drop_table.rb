class DropTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :verbs
    drop_table :list_verbs
    drop_table :result_verbs
    drop_table :nouns
    drop_table :list_nouns
    drop_table :result_nouns
    drop_table :adjectives
    drop_table :list_adjectives
    drop_table :result_adjectives
  end
end
