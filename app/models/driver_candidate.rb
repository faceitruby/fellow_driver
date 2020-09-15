# frozen_string_literal: true

# Drivers who accepted ride request
class DriverCandidate < ApplicationRecord
  enum status: { created: 0, accepted: 1, dismissed_by_requestor: 2, dismissed_by_candidate: 3 }

  belongs_to :driver, class_name: 'User'
  belongs_to :ride

  validates :driver_id, uniqueness: { scope: :ride_id, message: 'has already accepted this ride' }
  # only one candidate can be accepted or pending at one time
  # validates :accepted, uniqueness: true, if: -> { accepted_nil? || accepted_true? }

  private

  def presenter_class
    DriverCandidatePresenter
  end

  # def accepted_nil?
  #   accepted.nil?
  # end
  #
  # def accepted_true?
  #   accepted == true
  # end
end
