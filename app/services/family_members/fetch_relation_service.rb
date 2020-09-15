# frozen_string_literal: true

module FamilyMembers
  class FetchRelationService < FamilyMembers::ApplicationService
    # @attr_reader params [Hash]
    # - passengers [Array] Array of user ids

    def call
      check_passengers!

      passengers.map do |user|
        {
          relation: user.member_type == 'owner' ? 'me' : user.member_type,
          name: user.first_name
        }
      end
    end

    private

    def passengers
      @passengers ||= begin
        raise ArgumentError, 'Passengers are missing' unless params[:passengers].presence

        User.find params[:passengers].presence
      end
    end

    # passengers must be in one family
    def check_passengers!
      raise ArgumentError, 'Passengers are in different families' unless passengers.pluck(:family_id).uniq.size == 1
    end
  end
end
