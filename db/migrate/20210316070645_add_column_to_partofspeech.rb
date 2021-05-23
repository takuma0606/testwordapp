class AddColumnToPartofspeech < ActiveRecord::Migration[5.2]
  def change
    add_column :partofspeeches, :user_id, :integer
  end
end
