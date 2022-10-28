class CreateJwtTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :jwt_tokens do |t|
      t.integer :user_id
      t.string :token

      t.timestamps
    end
  end
  
end
