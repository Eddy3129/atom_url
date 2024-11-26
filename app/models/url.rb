# frozen_string_literal: true

# app/models/url.rb

# This model defines relationship of url with users and visits
class Url < ApplicationRecord
  belongs_to :user, optional: true # optional for non-logged-in users
  has_many :visits, dependent: :destroy

  validates :original_url, presence: true, format: { with: %r{\Ahttps?://[\S]+\z}, message: :invalid_format }
  validates :short_code, presence: true, uniqueness: true

  after_initialize :set_defaults

  before_validation :assign_short_code, on: :create

  private

  def assign_short_code
    self.short_code ||= generate_unique_short_code
  end

  def generate_unique_short_code
    loop do
      code = SecureRandom.alphanumeric(6)
      break code unless Url.exists?(short_code: code)
    end
  end

  def set_defaults
    self.visit_count ||= 0
  end
end
