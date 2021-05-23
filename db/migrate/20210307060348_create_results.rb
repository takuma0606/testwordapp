class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.string :answer
      t.string :solution

      t.timestamps
    end
  end
end
