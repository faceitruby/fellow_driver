# frozen_string_literal: true

class RideMessage < ApplicationRecord
  belongs_to :template, class_name: 'RideTemplate', foreign_key: :ride_template_id, optional: true
  belongs_to :ride

  validate :message_or_template

  private

  def presenter_class
    RideMessagePresenter
  end

  def message_or_template
    errors.add(:message_and_template, 'are missing') if message_template_missing?
    errors.add(:message_or_template, 'can\'t be both present at once') if message_template_present?
  end

  def message_template_missing?
    message.present? == false && template.present? == false
  end

  def message_template_present?
    message.present? == true && template.present? == true
  end
end
