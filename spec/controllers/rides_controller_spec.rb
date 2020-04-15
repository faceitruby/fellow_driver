require 'rails_helper'

RSpec.describe RidesController, type: :controller do
  describe 'routes' do
    it { is_expected.to route(:post, '/api/rides/check').to(action: :check, format: :json) }
  end

  describe 'calbacks' do
    it { is_expected.to use_before_action(:check_authorize) }    
  end

  describe '#check' do
    let(:user) { build(:user) }
    let(:send_request) { post :check}
    subject { response }

    # OPTIMIZE: CHECK TIME DIFFERENCE WITH STUBS AND WITHOUT ONES
    before do
      expect(Rides::RideCheckService).to receive(:perform).and_return(result)
      allow(controller).to receive(:check_authorize)
      allow(controller).to receive(:current_user).and_return(user)
      send_request
    end

    context 'when success? is true' do
      let(:result) { OpenStruct.new(success?: true, errors: nil, data: { message: 'ok' }) }

      it { is_expected.to have_http_status(:ok) }
      it { expect(subject.content_type).to include 'application/json' }
      it { expect(subject.parsed_body['errors']).to_not be_present }
      it { expect(subject.parsed_body['data']).to be_present }
      it { expect(subject.parsed_body['data']['message']).to eq 'ok' }
      it { expect(subject.parsed_body['success?']).to be true }
    end

    context 'when success? is false' do
      let(:result) { OpenStruct.new(success?: false, errors: 'error', data: nil) }

      it { is_expected.to have_http_status(:ok) }
      it { expect(subject.content_type).to include 'application/json' }
      it { expect(subject.parsed_body['errors']).to be_present }
      it { expect(subject.parsed_body['data']).to_not be_present }
      it { expect(subject.parsed_body['success?']).to be false }
    end
  end
end
