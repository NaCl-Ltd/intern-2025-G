class FavoritesController < ApplicationController
    def create
        @post_favorite = Favorite.new(user_id: current_user.id, micropost_id: params[:micropost_id])
        @post_favorite.save
        redirect_to micropost_path(params[:micropost_id]) 
    end
    def destroy
        @post_favorite = Favorite.find_by(user_id: current_user.id, micropost_id: params[:micropost_id])
        @post_favorite.destroy
        redirect_to micropost_path(params[:micropost_id]) 
    end


    
end
