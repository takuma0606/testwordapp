class AddColumn < ActiveRecord::Migration[5.2]
  def change
    add_column:words, :user_id, :id
  end
end
