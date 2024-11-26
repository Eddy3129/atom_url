# frozen_string_literal: true

# AnalyticsController: Displays URL visit statistics by day, month, or year.
# app/controllers/analytics_controller.rb
class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_url

  def show
    @visit_counts = visit_counts_by_period(params[:period])
    @geo_distribution = @url.visits.group(:country).count
    @visits = @url.visits.order(created_at: :desc)
  end

  private

  def set_url
    @url = current_user.urls.find(params[:id]) # Only fetch URLs belonging to the signed-in user
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: t('alerts.url_not_found')
  end

  def visit_counts_by_period(period)
    case period
    when 'month'
      @url.visits.group_by_month(:created_at).count
    when 'year'
      @url.visits.where(created_at: Time.zone.today.beginning_of_year..).group_by_day(:created_at).count
    else
      @url.visits.group_by_day(:created_at).count
    end
  end
end
