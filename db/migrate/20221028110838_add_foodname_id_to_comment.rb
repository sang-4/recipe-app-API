class AddFoodnameIdToComment < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :foodname_id, :integer
  end
end
