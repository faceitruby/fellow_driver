module Rides
  class CreateService < ApplicationService
    def call
      # start = Geocoder.search(params['start_address']).first.cordinates
      # finish = Geocoder.search(params['end_address']).first.coordinates
      # distance = Geocoder::Calculations.distance_between(start, finish)
      start = [47.8042886, 35.1844086]
      finish = [47.8253701, 35.1664671]
      distance = 1.677687197407667

      ride = Ride.new(params.except(:start_address, :end_address))
      ride.start_address = start
      ride.end_address = finish
      byebug
      ride.build_ride_message(message: params['message'], kind: kind)
      byebug
      return OpenStruct.new(success?: false, errors: ride.errors, data: nil) unless ride.save!

      OpenStruct.new(success?: true, errors: nil, data: ride)
    end

    private

    def kind
      # RideMessage.templates.include? params['message'] ? 
      # RideMessage.kinds[:custom]
    end
  end
end