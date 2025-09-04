class AddMicropostIdToFavorites < ActiveRecord::Migration[7.0]
  def change
    add_column :favorites, :micropost_id, :integer
  end
end