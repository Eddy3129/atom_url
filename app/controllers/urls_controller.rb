class UrlsController < ApplicationController
  def index
    @url = Url.new
    @urls = Url.order(created_at: :desc).page(params[:page]).per(10)
  end

  def create
    @url = UrlShortenerService.new(url_params[:original_url]).shorten
    @urls = Url.order(created_at: :desc).page(params[:page]).per(10)

    respond_to do |format|
      if @url.persisted?
        format.turbo_stream
        format.html { redirect_to root_path, notice: "URL was successfully shortened." }
      else
        flash.now[:alert] = @url.errors.full_messages.join(", ")
        format.turbo_stream { render :index, status: :unprocessable_entity }
        format.html { render :index }
      end
    end
  end

  def destroy
    @url = Url.find(params[:id])
    @url.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to urls_path, notice: "URL was successfully deleted." }
    end
  end

  def bulk_delete
    ids = params[:url_ids] || []
    Url.where(id: ids).destroy_all

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(ids.map { |id| "url_#{id}" }) }
      format.html { redirect_to urls_path, notice: "#{ids.size} URLs were successfully deleted." }
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url, :title)
  end
end
