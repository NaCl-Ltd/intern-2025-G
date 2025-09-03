class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def latest
    @microposts = Micropost.latest(current_user)
  end

  def fix
=begin    @micropost = Micropost.find(params[:id])
    if @micropost.fixed.to_i == 1
      @micropost.update(fixed: 0)
    else
      @micropost.update(fixed: 1)
    end
    redirect_to request.referer || root_url
=end
    @micropost = Micropost.find(params[:id])
    if current_user.microposts.exists?(fixed: 1)
      current_user.microposts.update(fixed: 0)
    end
    @micropost.update(fixed: 1)
    redirect_to request.referer || root_url
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    if request.referrer.nil?
      redirect_to root_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @micropost.nil?
    end
end
