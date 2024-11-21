class UrlsController < ApplicationController
  def index
    @url = Url.new
    @urls = Url.order(created_at: :desc).limit(10)
  end

  def create
    @url = UrlShortenerService.new(url_params[:original_url]).shorten
    if @url
      redirect_to @url, notice: "URL was successfully shortened."
    else
      @url = Url.new(url_params)
      @urls = Url.order(created_at: :desc).limit(10)
      flash.now[:alert] = "Failed to shorten URL."
      render :index
    end
  end

  def show
    @url = Url.find(params[:id])
    @visits = @url.visits.order(created_at: :desc)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "URL not found."
  end

  def redirect
    @url = Url.find_by(short_code: params[:short_code])

    if @url
      @url.increment!(:visit_count) # Optional: Track visit counts
      redirect_to @url.original_url, allow_other_host: true
    else
      redirect_to root_path, alert: "Short URL not found."
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end
end
