# frozen_string_literal: true

# ApplicationService with common methods for vehicles
class Vehicles::ApplicationService < ApplicationService
  private

  def examples(url, key)
    JSON.parse(response(url))['Results'].flat_map { |v| v[key] }
  end

  def response(uri)
    Net::HTTP.get(uri)
  end
end
