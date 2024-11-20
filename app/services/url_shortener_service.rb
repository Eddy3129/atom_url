class UrlShortenerService
  def initialize(original_url)
    @original_url = original_url
  end

  def shorten
    url = Url.create!(original_url: @original_url, title: fetch_title)
    url
  rescue StandardError => e
    # Handle exceptions, possibly log them
    nil
  end

  private

  def fetch_title
    uri = URI.parse(@original_url)
    response = Net::HTTP.get(uri)
    Nokogiri::HTML(response).title
  rescue
    'No Title'
  end
end
