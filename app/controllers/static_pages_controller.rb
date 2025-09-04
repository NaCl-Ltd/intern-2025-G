class StaticPagesController < ApplicationController

  def home
  if logged_in?
    if params[:q].present?
      @microposts = Micropost.search_by_content(params[:q])
      @feed_items = @microposts.paginate(page: params[:page])
    else
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
end

  def help
  end

  def about
  end

  def contact
  end
end
