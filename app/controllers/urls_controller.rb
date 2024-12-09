# frozen_string_literal: true

# This controller manages the creation, display, and deletion of shortened URLs.
class UrlsController < ApplicationController
  # @method index
  # Displays the list of URLs for the current user or public URLs.
  def index
    @url = Url.new
    @urls = fetch_urls
  end

  # @method create
  # Creates a new shortened URL and associates it with the user, if signed in.
  #
  # @param url_params [ActionController::Parameters] The parameters used to create a new URL
  # @return [void]
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

  # @method destroy
  # Deletes a URL if it belongs to the currently logged-in user.
  #
  # @param id [Integer] The ID of the URL to be deleted
  # @return [void]
  def destroy
    @url = Url.find(params[:id])

    # Ensure that the user can only delete their own URLs
    if @url.user == current_user
      @url.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove(@url) # Remove the deleted URL from the page
        end
        format.html { redirect_to urls_path, notice: I18n.t('notices.url_deleted') }
      end
    else
      redirect_to urls_path, alert: I18n.t('alerts.url_unauthorized_delete')
    end
  end

  private

  # @method create_url
  # Handles the URL creation logic, including URL shortening and user association.
  #
  # @param original_url [String] The original URL to shorten
  # @return [Url] The newly created shortened URL object
  def create_url(original_url)
    url = UrlShortenerService.new(original_url).shorten
    url.user_id = current_user.id if user_signed_in?
    url
  end

  # @method Handle successful URL creation (Turbo Stream response)
  def handle_successful_create
    render turbo_stream: [
      turbo_stream.append('recent-urls', partial: 'url', locals: { url: @url }),
      turbo_stream.replace('form-container', partial: 'form_success', locals: { url: @url })
    ]
  end

  # @method Handle failed URL creation (Turbo Stream response)
  def handle_failed_create
    render turbo_stream: turbo_stream.replace('form-container', partial: 'form', locals: { url: @url })
  end

  # @method Fetch URLs for the current user or public URLs if not signed in
  def fetch_urls
    if user_signed_in?
      current_user.urls.order(created_at: :desc).page(params[:page]).per(10)
    else
      Url.where(user_id: nil).order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  # @method url_params
  # Defines and filters the permitted parameters for creating or updating URLs.
  def url_params
    params.require(:url).permit(:original_url, :title)
  end
end
