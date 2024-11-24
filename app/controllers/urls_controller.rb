# frozen_string_literal: true

# Manages URL creation, listing, deletion, and deletion actions.
class UrlsController < ApplicationController
  def index
    @url = Url.new
    @urls = fetch_urls
  end

  def create
    @url = UrlShortenerService.new(url_params[:original_url]).shorten
    @urls = fetch_urls
    handle_response(@url)
  end

  def destroy
    @url = Url.find(params[:id])
    @url.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to urls_path, notice: t('notices.url_deleted') }
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url, :title)
  end

  def fetch_urls
    Url.order(created_at: :desc).page(params[:page]).per(10)
  end

  def handle_response(url)
    respond_to do |format|
      if url.persisted?
        format.turbo_stream
        format.html { redirect_to root_path, notice: t('notices.url_shortened') }
      else
        set_flash_alert(url)
        format.turbo_stream { render :index, status: :unprocessable_entity }
        format.html { render :index }
      end
    end
  end

  def flash_alert(url)
    flash.now[:alert] = url.errors.full_messages.join(', ')
  end
end
