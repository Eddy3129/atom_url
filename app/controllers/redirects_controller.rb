class RedirectsController < ApplicationController
  def show
    url = Url.find_by(short_code: params[:short_code])
    if url
      # Create a Visit record with IP address; state and country will be populated via the model callback
      url.visits.create(ip_address: request.remote_ip)
      redirect_to url.original_url, allow_other_host: true
    else
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end
end
