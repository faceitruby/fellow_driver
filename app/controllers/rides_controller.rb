class RidesController < ApplicationController
  def family_members
    return unless check.success?

    warn "[WARN] !!!!!!!!!!!!!"
    render_success_response({qwe:1}, 415)
  end

  def create
    qwe = messages
    byebug
    result = Rides::CreateService.perform(create_params)
    result.success? ? render_success_response(result.data, :created) : render_error_response(result.errors, :unprocessable_entity)
  end

  private

  def check_params
    { user: current_user }
  end

  def create_params
    params.require(:ride).permit(:users, :start_address, :end_address, :date, :payment, :message)
          .merge(user: current_user)
  end

  # The first check, ensures payment and family are already set, redirect to 
  def check
    result = Rides::RideCheckService.perform(check_params)

    # result.success? ? render_response(result.data.to_json) : render_response(result.errors.to_json)
    # OPTIMIZE: GET RID OF TABLE WITH ANOTHER WAY
    render_response(result.marshal_dump.to_json) unless result.success?
    result
  end

  def messages
    messages = RideMessage.template.pluck(:message)

    messages.each do |message|
      byebug
      message.sub!('location', params['start_address'])
      message.sub!('date'. params['date'])
    end
    messages
  end
end
