
class AnalyticsController < ApplicationController
  before_action :set_url

  def show
    @url = Url.find(params[:id])
    
    period = params[:period] || 'day'
    case period
    when 'day'
      @visit_counts = @url.visits.group_by_day(:created_at).count
    when 'month'
      @visit_counts = @url.visits.group_by_month(:created_at).count
    when 'year'
      @visit_counts = @url.visits.where('created_at >= ?', Date.today.beginning_of_year).group_by_day(:created_at).count
    else
      @visit_counts = @url.visits.group_by_day(:created_at).count
    end

    @geo_distribution = @url.visits.group(:country).count
    @visits = @url.visits.order(created_at: :desc)
  end

  private

  def set_url
    @url = Url.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "URL not found."
  end
end
