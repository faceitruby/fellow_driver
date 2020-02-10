module Users
  class RegistrationService < ApplicationService
    def initialize(params)
      @params = params.require(:user).permit(:email, :phone, :password, :password_confirmation)
    end

    def execute
      @user = User.new(@params)
      return OpenStruct.new(success?: false, user: nil, errors: @user.errors) unless @user.save
      OpenStruct.new(success?: true, user: @user, errors: nil)
    end
  end
end