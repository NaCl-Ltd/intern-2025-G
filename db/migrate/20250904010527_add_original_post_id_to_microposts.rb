class AddOriginalPostIdToMicroposts < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :original_post_id, :integer
  end
end
