class FavoritesController < ApplicationController
    def create
        @micropost_favorite = Favorite.new(user_id: current_user.id, micropost_id: params[:micropost_id])
        @micropost_favorite.save
        redirect_to micropost_path(params[:micropost_id])
    end

    def destroy
        @micropost_favorite = Favorite.find_by(user_id: current_user.id, micropost_id: params[:micropost_id])
        @micropost_favorite.destroy if @micropost_favorite.present?
        redirect_to micropost_path(params[:micropost_id])
    end
end
