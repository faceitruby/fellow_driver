# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VehiclesController, type: :controller do
  context 'routing' do
    it do
      expect(get: '/api/brands').to route_to(
        controller: 'vehicles',
        action: 'brands',
        format: :json
      )
    end

    it do
      expect(get: '/api/models/test').to route_to(
        controller: 'vehicles',
        action: 'models',
        format: :json,
        brand: 'test'
      )
    end
  end

  context 'when response from API' do
    let(:user) { create(:user) }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    context 'is susuccess' do
      it 'return success for brands' do
        request.headers['token'] = token

        stub_request(:get, "https://vpic.nhtsa.dot.gov/api/vehicles/GetMakesForVehicleType/car?format=json").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'vpic.nhtsa.dot.gov',
            'User-Agent'=>'Ruby'
          }).
        to_return(status: 200, body: '{
          "Count":1,
          "Message":"Response returned successfully",
          "SearchCriteria":"VehicleType: car",
          "Results":[{
            "MakeId":440,
            "MakeName":"Aston Martin",
            "VehicleTypeId":2,
            "VehicleTypeName":"PassengerCar"
            }
          ]}', headers:{})
        stub_request(:get, 'https://vpic.nhtsa.dot.gov/api/vehicles/GetMakesForVehicleType/bus?format=json').
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'vpic.nhtsa.dot.gov',
            'User-Agent'=>'Ruby'
          }).
        to_return(status: 200, body: '{
          "Count":1,
          "Message":"Response returned successfully",
          "SearchCriteria":"VehicleType: bus",
          "Results":[{
            "MakeId":449,
            "MakeName":"Mercedes-Benz",
            "VehicleTypeId":5,
            "VehicleTypeName":"Bus"
            }
          ]}', headers:{})

        get 'brands'
        expect(response).to have_http_status(200)
      end

      it 'return success for models by brand' do
        request.headers['token'] = token

        stub_request(:get, 'https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformake/tesla?format=json').
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host'=>'vpic.nhtsa.dot.gov',
            'User-Agent'=>'Ruby'
          }).
        to_return(status: 200, body: '{
          "Count":5,
          "Message":"Response returned successfully",
          "SearchCriteria":"Make:tesla",
          "Results":[{
            "Make_ID":441,
            "Make_Name":"Tesla",
            "Model_ID":1685,
            "Model_Name":"ModelS"
            }
          ]}', headers:{})

        get 'models', params: { brand: 'tesla' }
        expect(response).to have_http_status(200)
      end
    end
  end
end
