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

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    if request.referrer.nil?
      redirect_to root_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  def pin
    @micropost = Micropost.find(params[:id])

    if current_user.microposts.exists?(pinned: true)
      current_user.microposts.update(pinned: false)
    end

    @micropost.update(pinned: !@micropost.pinned) # true/false をトグル



    redirect_to microposts_path
  end

  def retweet
    original = Micropost.find(params[:id])
    current_user.microposts.create(original_post: original)
    redirect_to root_url, notice: "再投稿しました！"
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
