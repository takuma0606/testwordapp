class Add < ActiveRecord::Migration[5.2]
  def change
    add_column:results, :q_word, :string
  end
end
