class RemoveCreatedAtAndUpdatedAtFromMessages < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :created_at, :datetime
    remove_column :messages, :updated_at, :datetime
  end
end
