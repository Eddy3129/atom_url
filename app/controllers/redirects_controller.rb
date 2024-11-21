# app/controllers/redirects_controller.rb

class RedirectsController < ApplicationController
  def show
    url = Url.find_by(short_code: params[:short_code])
    if url
      # Create a Visit record with IP address; state and country will be populated via the model callback
      visit = url.visits.create(ip_address: request.remote_ip)

      if visit.persisted?
        Rails.logger.info "Visit recorded: #{visit.inspect}"
      else
        Rails.logger.error "Failed to record visit for Url ID #{url.id}: #{visit.errors.full_messages.join(', ')}"
      end

      redirect_to url.original_url, allow_other_host: true
    else
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end
end
