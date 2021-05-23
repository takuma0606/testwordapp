class ChangeDataUserIdToWords < ActiveRecord::Migration[5.2]
  def change
    change_column :words, :user_id, :integer
  end
end
