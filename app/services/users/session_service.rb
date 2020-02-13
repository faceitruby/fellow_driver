module Users
  class SessionService < ApplicationService
    def initialize(user)
      @user = user
    end

    def execute
      return OpenStruct.new(success?: false, user: nil, errors: 'Invalid Login or password') unless @user
      OpenStruct.new(success?: true, data: {token: jwt_encode(@user), user: @user}, errors: nil)
    end
  end
end
