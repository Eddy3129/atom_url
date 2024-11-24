# app/models/url.rb

class Url < ApplicationRecord
  has_many :visits, dependent: :destroy

  validates :original_url, presence: true, format: { with: /\Ahttps?:\/\/[\S]+\z/, message: "must be a valid URL starting with http:// or https://" }
  validates :short_code, presence: true, uniqueness: true

  before_create :generate_unique_short_code

  private

  
  def assign_short_code
    self.short_code = generate_unique_short_code
  end

  def generate_unique_short_code
    loop do
      code = SecureRandom.alphanumeric(6)
      break code unless Url.exists?(short_code: code)
    end
  end
end

