class AddLikeBookmarkColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :like, :boolean, default: false
    add_column :users, :bookmark, :boolean, default: false
  end
end
