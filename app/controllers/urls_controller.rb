# frozen_string_literal: true

# This controller manages the creation, display, and deletion of shortened URLs.
class UrlsController < ApplicationController
  # GET /urls
  def index
    @url = Url.new
    @urls = fetch_urls
  end

  # POST /urls
  def create
    @url = create_url(url_params[:original_url])

    respond_to do |format|
      if @url.save
        format.turbo_stream { handle_successful_create }
        format.html { redirect_to root_path, notice: I18n.t('notices.url_shortened') }
      else
        format.turbo_stream { handle_failed_create }
        format.html { render :new }
      end
    end
  end

  # DELETE /urls/:id
  def destroy
    @url = Url.find(params[:id])

    # Ensure that the user can only delete their own URLs
    if @url.user == current_user
      @url.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to urls_path, notice: I18n.t('notices.url_deleted') }
      end
    else
      redirect_to urls_path, alert: I18n.t('alerts.url_unauthorized_delete')
    end
  end

  private

  # Refactored to handle URL creation and user association logic
  def create_url(original_url)
    url = UrlShortenerService.new(original_url).shorten
    url.user_id = current_user.id if user_signed_in?
    url
  end

  # Handle successful URL creation (Turbo Stream response)
  def handle_successful_create
    render turbo_stream: [
      turbo_stream.append('recent-urls', partial: 'url', locals: { url: @url }),
      turbo_stream.replace('form-container', partial: 'form_success', locals: { url: @url })
    ]
  end

  # Handle failed URL creation (Turbo Stream response)
  def handle_failed_create
    render turbo_stream: turbo_stream.replace('form-container', partial: 'form', locals: { url: @url })
  end

  # Fetch URLs for the current user or public URLs if not signed in
  def fetch_urls
    if user_signed_in?
      current_user.urls.order(created_at: :desc).page(params[:page]).per(10)
    else
      Url.where(user_id: nil).order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  # Strong parameters for URL
  def url_params
    params.require(:url).permit(:original_url, :title)
  end
end
