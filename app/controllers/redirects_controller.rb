# frozen_string_literal: true

# app/controllers/redirects_controller.rb

# Redirects to the original URL if found; logs visit details.
class RedirectsController < ApplicationController
  # @param short_code [String] The shortened URL code to redirect to.
  # @return [void]
  #
  # @method show
  # Redirects to the original URL and logs visit details.
  def show
    url = find_url_by_short_code(params[:short_code])
    if url
      record_visit(url)
      increment_visit_count(url)
      redirect_to url.original_url, allow_other_host: true
    else
      render_not_found
    end
  end

  private

  # @method find_url_by_short_code
  # Finds the URL by its short code.
  #
  # @param short_code [String] The shortened URL code
  def find_url_by_short_code(short_code)
    Url.find_by(short_code: short_code)
  end

  # @method record_visit
  # Records a visit for the given URL, including geolocation data.
  #
  # @param url [Url] The URL object for which the visit is being recorded
  # @return [void]
  def record_visit(url)
    visit = url.visits.create(ip_address: request.remote_ip)

    if visit.persisted?
      Rails.logger.info "Visit recorded: #{visit.inspect}"

      geo_service = GeolocationService.new(visit.ip_address)
      geolocation = geo_service.fetch_geolocation

      if geolocation[:error].nil?
        visit.update(
          state: geolocation[:state],
          country: geolocation[:country],
          latitude: geolocation[:latitude],
          longitude: geolocation[:longitude]
        )
        Rails.logger.info "Visit geolocation updated: #{geolocation[:state]}, #{geolocation[:country]}, #{geolocation[:latitude]}, #{geolocation[:longitude]}"
      else
        Rails.logger.error "Geolocation error for IP #{visit.ip_address}: #{geolocation[:error]}"
      end
    else
      Rails.logger.error "Failed to record visit for Url ID #{url.id}: #{visit.errors.full_messages.join(', ')}"
    end
  end

  # @method increment_visit_count
  # Increments the visit count for the given URL.
  #
  # @param url [Url] The URL object whose visit count will be incremented
  # @return [void]
  def increment_visit_count(url)
    url.update(visit_count: url.visit_count + 1)
  end

  # @method render_not_found
  # Renders a custom 404 error page when the URL is not found.
  #
  # @return [void]
  def render_not_found
    render file: Rails.public_path.join('404.html').to_s, status: :not_found
  end
end
