# frozen_string_literal: true

module Rides
  module Messages
    # base class for templates fetching
    class TemplatesService < ApplicationService
      # @attr_reader params [Hash]
      # - id: [Integer] Chosen template id
      # - time [String] Picked time
      # - start_address [String] Ride start address
      # - end_address [String] Ride finish address
      # - passengers [Array] Array with passenger ids

      RELATION_GROUPS = { kids: %w[son daughter], parents: %w[mother father] }.freeze

      def call
        check_params!
      end

      private

      def receive_template(template, parsed_time = parse_time)
        receive_template!(template.dup, parsed_time)
      end

      def receive_template!(template, parsed_time = parse_time)
        template.text.sub!('relationship name', relation_with_name)
        template.text.sub!('start_address', start_address)
        template.text.sub!('end_address', end_address)
        template.text.sub!('date', parsed_time)
        template
      end

      def parse_time(ride_created_time = Time.current)
        @parse_time ||= case scheduled_time.day
                        when ride_created_time.day
                          'today'
                        when ride_created_time.tomorrow.day
                          'tomorrow'
                        when ride_created_time.at_beginning_of_week.day..ride_created_time.at_end_of_week.day
                          "on #{scheduled_time.strftime('%A')}" # 'on Monday'
                        else
                          "on #{scheduled_time.strftime('%-d %b %I:%M %p')}" # example 'on 22 Aug 06:10 PM'
                        end
      end

      def start_address
        @start_address ||= params[:start_address].presence
      end

      def end_address
        @end_address ||= params[:end_address].presence
      end

      def passengers
        @passengers ||= begin
          raise ArgumentError, 'Passengers are missing' unless params[:passengers].presence

          FamilyMembers::FetchRelationService.perform passengers: params[:passengers].presence
        end
      end

      def relation_with_name
        @relation_with_name ||= begin
          raise ArgumentError, 'List of passengers can`t be blank' if passengers.blank?

          result = []
          me_present = passengers.any? { |passenger| passenger[:relation] == 'me' }
          if me_present
            result << 'me'
            result << 'and' if passengers.size > 1
          end
          result << 'my' if result.blank? || passengers.size > 1
          RELATION_GROUPS.each_pair do |group, values|
            found = passengers.select { |passenger| values.include? passenger[:relation] }
            if found.size == 1
              result << found.first[:relation] << found.first[:name] << 'and'
            elsif found.size > 1
              result << group
              found.each do |user|
                result << user[:name] << 'and'
              end
            end
          end
          result.pop if result.last == 'and'
          result.join ' '
        end
      end

      def scheduled_time
        Time.zone.parse params[:time].presence
      end

      # TODO: CHANGE TO REAL
      def approximate_travel_time
        0
      end

      def time_buffer
        10.minutes
      end

      def correct_time?(time)
        time && time > (Time.current + approximate_travel_time + time_buffer)
      end

      def id
        params[:id].presence
      end

      def check_params!
        raise ArgumentError, 'Passengers are missing' unless passengers
        raise ArgumentError, 'Time is missing' unless params[:time]
        raise ArgumentError, 'Start address is missing' unless start_address
        raise ArgumentError, 'End address is missing' unless end_address
      end
    end
  end
end
