class AddOriginalPostIdToMicroposts < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :original_post_id, :integer
    add_foreign_key :microposts, :microposts, column: :original_post_id
  end
end
