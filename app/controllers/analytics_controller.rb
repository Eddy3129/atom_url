# frozen_string_literal: true

# AnalyticsController: Displays URL visit statistics by day, month, or year.
class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_url

  # Displays the visit statistics for a given URL based on the selected time period.
  #
  # @param period [String] The time period for analytics (can be 'day', 'month', 'year')
  # @return [void]
  def show
    @visit_counts = visit_counts_by_period(params[:period])
    @geo_distribution = geo_distribution_by_period(params[:period])
    @visits = visits_by_period(params[:period])
  end

  private

  # Sets the @url instance variable to the URL associated with the current user.
  # If the URL is not found, redirects to the root path with an error message.
  #
  # @return [void]
  def set_url
    @url = current_user.urls.find(params[:id]) # Only fetch URLs belonging to the signed-in user
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: t('alerts.url_not_found')
  end

  # Returns the visit counts grouped by the specified time period.
  #
  # @param period [String] The time period for visit counts ('day', 'month', or 'year')
  # @return [Hash] A hash with the time period as keys and visit counts as values
  def visit_counts_by_period(period)
    case period
    when 'month'
      # Group by month, format as full month name
      @url.visits.where(created_at: 1.year.ago..Time.zone.now)
          .group_by_month(:created_at, format: '%B')
          .count
    when 'year'
      # Group by year, format as full year
      @url.visits.where(created_at: 5.years.ago..Time.zone.now)
          .group_by_year(:created_at, format: '%Y')
          .count
    else
      # Group by day of the week (Monday, Tuesday, etc.) for past week
      @url.visits.where(created_at: 7.days.ago..Time.zone.now)
          .group_by_day(:created_at, format: '%A')
          .count
    end
  end

  # Returns the geo-distribution of visits for the specified time period.
  #
  # @param period [String] The time period for geo-distribution ('day', 'month', or 'year')
  # @return [Hash] A hash with countries as keys and visit counts as values
  def geo_distribution_by_period(period)
    case period
    when 'month'
      @url.visits.where(created_at: Time.zone.today.beginning_of_month..).group(:country).count
    when 'year'
      @url.visits.where(created_at: Time.zone.today.beginning_of_year..).group(:country).count
    else
      @url.visits.where(created_at: 7.days.ago..Time.zone.now).group(:country).count
    end
  end

  # @method visits_by_period
  # Returns the list of visits for the given time period, ordered by the creation date.
  #
  # @param period [String] The time period for the visits ('day', 'month', or 'year')
  # @return [ActiveRecord::Relation] A collection of Visit records
  def visits_by_period(period)
    case period
    when 'month'
      # If 'month' is selected, show visits from all months (no restriction on current month)
      @url.visits.where(created_at: 1.year.ago..Time.zone.now).order(created_at: :desc)
    when 'year'
      # If 'year' is selected, show visits from all years (no restriction on current year)
      @url.visits.where(created_at: 5.years.ago..Time.zone.now).order(created_at: :desc)
    else
      # For 'week', show visits from the last 7 days
      @url.visits.where(created_at: 7.days.ago..Time.zone.now).order(created_at: :desc)
    end
  end
end
