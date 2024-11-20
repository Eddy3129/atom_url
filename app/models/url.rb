class Url < ApplicationRecord
  has_many :visits, dependent: :destroy

  validates :original_url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :short_code, presence: true, uniqueness: true, length: { maximum: 15 }

  before_validation :generate_short_code, on: :create

  private

  def generate_short_code
    loop do
      self.short_code = SecureRandom.urlsafe_base64(9) # Generates 12-character string
      break unless Url.exists?(short_code: short_code)
    end
  end
end
