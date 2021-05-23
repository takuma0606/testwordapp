class Change < ActiveRecord::Migration[5.2]
  def change
    remove_column:lists, :meaning, :string
    add_column:lists, :meaning, :text
    add_column:lists, :user_id, :integer
  end
end
