class AddResult < ActiveRecord::Migration[5.2]
  def change
    add_column:results, :user_id, :integer
  end
end
