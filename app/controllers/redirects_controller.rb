# frozen_string_literal: true

# app/controllers/redirects_controller.rb

# Redirects to the original URL if found; logs visit details.
class RedirectsController < ApplicationController
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

  def find_url_by_short_code(short_code)
    Url.find_by(short_code: short_code)
  end

  def record_visit(url)
    visit = url.visits.create(ip_address: request.remote_ip)
    if visit.persisted?
      Rails.logger.info "Visit recorded: #{visit.inspect}"

      geo_service = GeolocationService.new(visit.ip_address)
      geolocation = geo_service.fetch_geolocation

      if geolocation[:error].nil?
        visit.update(
          state: geolocation[:state],
          country: geolocation[:country]
        )
        Rails.logger.info "Visit geolocation updated: #{geolocation[:state]}, #{geolocation[:country]}"
      end
    else
      Rails.logger.error "Failed to record visit for Url ID #{url.id}: #{visit.errors.full_messages.join(', ')}"
    end
  end

  def increment_visit_count(url)
    url.update(visit_count: url.visit_count + 1)
  end

  def render_not_found
    render file: Rails.public_path.join('404.html').to_s, status: :not_found
  end
end
