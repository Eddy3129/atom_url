class UrlsController < ApplicationController
  def index
    @url = Url.new
    @urls = Url.order(created_at: :desc).limit(10)
  end

  def create
    @url = Url.new(url_params)
    if @url.save
      redirect_to @url, notice: "URL was successfully shortened."
    else
      @urls = Url.order(created_at: :desc).limit(10)
      render :index
    end
  end

  def show
    @url = Url.find(params[:id])
    @visits = @url.visits.order(created_at: :desc)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "URL not found."
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end
end
