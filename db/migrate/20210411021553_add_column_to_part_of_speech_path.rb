class AddColumnToPartOfSpeechPath < ActiveRecord::Migration[5.2]
  def change
    add_column :partofspeeches, :path, :string
  end
end
