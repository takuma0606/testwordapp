class AddColumnToResultQId < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :q_id, :integer
  end
end
