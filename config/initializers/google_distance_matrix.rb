GoogleDistanceMatrix.configure_defaults do |config|
  config.mode = 'driving'
  config.avoid = 'tolls'
  config.google_api_key = ENV['GOOGLE_PLACES_API_KEY']
end
