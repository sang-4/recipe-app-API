class AddExpiryToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :exp, :datetime
  end
end
