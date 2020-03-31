# frozen_string_literal: true

module Rides
  module Messages
    class FetchTemplatesService < ApplicationService
      # @attr_reader params [Hash]
      # - date [ActiveSupport::TimeWithZone] Picked date
      # - start_address [String] Ride start address

      RELATION_GROUPS = { kids: %w[son daughter], parents: %w[mother father] }

      # I guess missing id in params means fetching templates for frontend side within ride creating
      # id presence in params means fetching template from existing ride for admin panel
      def call
        if id.present?
          receive_template!(RideMessage.find(id))
        else
          templates = RideMessage.template
          templates.each { |template| receive_template!(template) }
          templates
        end
      end

      # private

      def receive_template(template)
        receive_template!(template.dup)
      end

      def receive_template!(template)
        template.message.sub!('relationship name', relation_with_name)
        template.message.sub!('location', location)
        template.message.sub!('date', time)
      end

      def time
        @time ||= lambda do
          # byebug
          return unless date && date.future?
          
          case date.day
          when Time.current.day
            'today'
          when Time.zone.tomorrow.day
            'tomorrow'
          when Time.current.at_beginning_of_week.day..Time.current.at_end_of_week.day
            "on #{date.strftime('%A')}"
          else
            "on #{date.to_formatted_s(:short)}"
          end
        end.call
      end

      def location
        # TODO: CHANGE TO FAVORITES ON WORKFLOW 8
        # favorites = FavoriteLocation.find(user_id: current_user.id)
        @location ||= lambda do
          favorite = nil
          favorite || params['start_address']
        end.call
      end

      # TODO: CHANGE TO REAL
      def passengers
        [
          { relation: 'son', name: 'Kostya', id: 123 },
          { relation: 'daughter', name: 'Lisa', id: 234 },
          { relation: 'mother', name: 'Olya', id: 345 },
          # { relation: 'father', name: 'Dima', id: 456 },
          # { relation: 'son', name: 'Oleg', id: 567 },
        ]
      end

      def relation_with_name
        @relation_name ||= lambda do
          result = []
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
          # result.display; puts
          result.pop if result.last == 'and'
          result.join ' '
        end.call
      end

      def date
        params[:date].presence
      end

      def id
        params[:id].presence
      end
    end
  end
end
